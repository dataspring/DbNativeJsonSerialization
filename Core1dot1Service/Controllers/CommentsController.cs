using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Core1dot1Service.Model;
using Microsoft.EntityFrameworkCore;
using System.Data.SqlClient;
using System.Data;
using Microsoft.Net.Http.Headers;
using System.Data.Common;
using Dapper;
using Microsoft.Extensions.Options;
using Core1dot1Service.Options;

namespace Core1dot1Service.Controllers
{
    public class CommentBlock
    {
        public string UserDisplayName;
        public int UserRating;
        public string Comment;
        public string CommentType;
        public DateTime UserLastUpdate;
        public List<Comment> Comments;
    }

    public class Comment
    {

        public int CommentId;
        public string Remarks;
        public int Rating;
        public DateTime CreatedDate;
        public Reply Reply;
    }

    public class Reply
    {

        public string Remarks;
        public DateTime CreatedDate;
    }



    [Route("api/[controller]")]
    public class CommentsController : Controller
    {
        private CommentContext _dbContext;
        public ConnectionConfig ConnectionConfig { get; }

        public CommentsController(CommentContext context, IOptions<ConnectionConfig> connectionConfig)
        {
            _dbContext = context;
            ConnectionConfig = connectionConfig.Value;
        }

        // GET api/values
        [HttpGet]
        [Route("method/jsonfromlinq")]
        public async Task<List<CommentBlock>> GetFromLinq(string ratingType, int courseId, int? userId = null, int skip = 0, int size = 10, int skipThread = 0, int sizeThread = 10 )
        {
            return await _dbContext.CommentSnapShots
                              .Where(r => r.CourseId == courseId && r.UserId == (userId ?? r.UserId) && r.CommentType == ratingType)
                              .Join(_dbContext.Users,
                                 r => r.UserId,
                                 u => u.UserId,
                                 (r, u) => new CommentBlock
                                 {
                                     UserDisplayName = u.DisplayName,
                                     UserRating = r.LastRating,
                                     Comment = r.LastRemarks,
                                     UserLastUpdate = r.LastUpdate,
                                     Comments = _dbContext.Comments.Where(c => c.CourseId == r.CourseId && c.UserId == r.UserId && c.CommentType == ratingType)
                                                             .Select(cm => new Comment
                                                             {
                                                                 CommentId = cm.CommentId,
                                                                 Rating = cm.Rating,
                                                                 Remarks = cm.Remarks,
                                                                 CreatedDate = cm.CreatedDate,
                                                                 Reply = _dbContext.Comments.Where(rp => rp.ParentId == cm.CommentId && rp.CommentType == (ratingType + "Reply"))
                                                                         .Select(ply => new Reply
                                                                         {
                                                                             Remarks = ply.Remarks,
                                                                             CreatedDate = ply.CreatedDate
                                                                         }).FirstOrDefault()
                                                             })
                                                               .OrderByDescending(o => o.CreatedDate)
                                                               .Skip(skipThread)
                                                               .Take(sizeThread)
                                                               .ToList()
                                 })
                                 .OrderByDescending(o => o.UserLastUpdate)
                                 .Skip(skip)
                                 .Take(size)
                                 .ToListAsync();
            
        }

        [HttpGet]
        [Route("method/jsonfromdb")]
        public async Task<ContentResult> GetFromDb(string ratingType, int? courseId, int? userId = null, int skip = 0, int size = 10,int skipThread = 0, int sizeThread = 10)
        {

            #region Params

            var ratingTypeParam = new SqlParameter
            {
                ParameterName = "@RatingType",
                DbType = DbType.String,
                Value = ratingType ?? (object)DBNull.Value
            };

            var courseIdParam = new SqlParameter
            {
                ParameterName = "@CourseId",
                DbType = DbType.Int32,
                Value = courseId ?? (object)DBNull.Value
            };

            var userIdParam = new SqlParameter
            {
                ParameterName = "@UserId",
                DbType = DbType.Int32,
                Value = userId ?? (object)DBNull.Value
            };
            var skipParam = new SqlParameter
            {
                ParameterName = "@Skip",
                DbType = DbType.Int32,
                Value = skip
            };
            var sizeParam = new SqlParameter
            {
                ParameterName = "@Size",
                DbType = DbType.Int32,
                Value = size > 20 ? 20 : size
            };
            var skipThreadParam = new SqlParameter
            {
                ParameterName = "@SkipThread",
                DbType = DbType.Int32,
                Value = skipThread
            };
            var sizeThreadParam = new SqlParameter
            {
                ParameterName = "@SizeThread",
                DbType = DbType.Int32,
                Value = sizeThread > 20 ? 20 : sizeThread
            };

            #endregion


            _dbContext.Database.OpenConnection();

            DbCommand dbCommand = _dbContext.Database.GetDbConnection().CreateCommand();
            dbCommand.CommandText = "GetComments";
            dbCommand.CommandType = CommandType.StoredProcedure;
            dbCommand.Parameters.AddRange(new[] { ratingTypeParam, courseIdParam, userIdParam, skipParam, sizeParam, skipThreadParam, sizeThreadParam });

            List<string> jsonResults = new List<string>();

            using (var dataReader = await dbCommand.ExecuteReaderAsync())
            {
                while (await dataReader.ReadAsync())
                    jsonResults.Add(dataReader.GetString(0));
            }

            return Content(string.Join("", jsonResults.ToArray()), new MediaTypeHeaderValue("application/json"));

        }

        [HttpGet]
        [Route("method/jsonfromdapper")]
        public async Task<ContentResult> GetFromDapper(string ratingType, int? courseId, int? userId = null, int skip = 0, int size = 10, int skipThread = 0, int sizeThread = 10)
        {


            using (var connection = new SqlConnection(ConnectionConfig.DefaultConnection))
            {
                connection.Open();

                DynamicParameters dp = new DynamicParameters();

                dp.Add("@RatingType", ratingType ?? (object)DBNull.Value, DbType.String);
                dp.Add("@CourseId", courseId ?? (object)DBNull.Value, DbType.Int32);
                dp.Add("@UserId", userId ?? (object)DBNull.Value, DbType.Int32);
                dp.Add("@Skip", skip, DbType.Int32);
                dp.Add("@Size", size > 20 ? 20 : size, DbType.Int32);
                dp.Add("@SkipThread", skipThread, DbType.Int32);
                dp.Add("@SizeThread", sizeThread > 20 ? 20 : sizeThread, DbType.Int32); ;


                var results = await connection.QueryAsync<string>("GetComments", dp, commandType: CommandType.StoredProcedure);

                List<string> jsonResults = new List<string>();

                return Content(string.Join("", results.ToArray()), new MediaTypeHeaderValue("application/json"));
            }

        }

    }
}
