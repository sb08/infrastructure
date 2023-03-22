using Microsoft.AspNetCore.Http;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace api.Extensions
{
    public static class RequestExtensions
    {
        public static async Task<string> GetRawBodyAsync(this HttpRequest request, Encoding encoding = null)
        {
            if (!request.Body.CanSeek)
            {
                request.EnableBuffering();
            }

            request.Body.Position = 0;
            var reader = new StreamReader(request.Body, encoding ?? Encoding.UTF8);
            var body = await reader.ReadToEndAsync().ConfigureAwait(false);
            request.Body.Position = 0;
            return body;
        }

        public static async Task<string> GetRawBodyAsync(this HttpResponse response, Encoding encoding = null)
        {
            
            //if (!response.Body.CanSeek)
            //{
            //    response.EnableBuffering();
            //}

            response.Body.Position = 0;
            var reader = new StreamReader(response.Body, encoding ?? Encoding.UTF8);
            var body = await reader.ReadToEndAsync().ConfigureAwait(false);
            response.Body.Position = 0;
            return body;
        }
    }
}
