using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using kore_api.koredb;
using kore_api.Repositories;
using kore_api.Repositories.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using kore_api.Util.Cognito;
using Swashbuckle.AspNetCore.Swagger;

namespace kore_api
{
    public class Startup
    {
        public const string AppS3BucketKey = "AppS3Bucket";

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public static IConfiguration Configuration { get; private set; }

        // This method gets called by the runtime. Use this method to add services to the container
        public void ConfigureServices(IServiceCollection services)
        {
			string[] arr = { "" };

			services.AddAuthorization(options =>
			{
				options.AddPolicy("IsAdmin", policy =>
					policy.Requirements.Add(new CognitoGroupAuthorizationRequirement(new string[] { "Admin" })));
				options.AddPolicy("IsAgent", policy =>
					policy.Requirements.Add(new CognitoGroupAuthorizationRequirement(new string[] { "Agent" })));
			    options.AddPolicy("IsAdminOrAgent", policy =>
				    policy.Requirements.Add(new CognitoGroupAuthorizationRequirement(new string[] { "Admin", "Agent" })));
			});

			services.AddSingleton<IAuthorizationHandler, CognitoGroupAuthorizationHandler>();
            services.AddAuthentication("Bearer")
                .AddJwtBearer(options =>
                {
                    options.Audience = "6fba0vhhhemve6bq3sm5evd0do";
                    options.Authority = "https://cognito-idp.us-east-2.amazonaws.com/us-east-2_G26JTdg5h";
                });
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new Info { Title = "Task Manager", Version = "v1" });
                c.AddSecurityDefinition("Bearer",
                    new ApiKeyScheme
                    {
                        In = "header",
                        Description = "Please enter into field the word 'Bearer' following by space and JWT",
                        Name = "Authorization",
                        Type = "apiKey"
                    });
                c.AddSecurityRequirement(new Dictionary<string, IEnumerable<string>> {
                                { "Bearer", Enumerable.Empty<string>() },
                            });
            });

            services.AddDbContext<koredbContext>(options =>
            options.UseMySQL("server=localhost;port=3306;user=root;password=password;database=koredb"));

            //Repos
            services.AddScoped<IAccountsRepository, AccountsRespository>();
            services.AddScoped<ITasksRepository, TasksRepository>();

            // Add S3 to the ASP.NET Core dependency injection framework.
            services.AddAWSService<Amazon.S3.IAmazonS3>();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseHsts();
            }
            app.UseAuthentication();
            app.UseHttpsRedirection();
            //app.UseMvc();
            app.UseMvc(routes =>
            {
                routes.MapRoute("default", "{controller=Home}/{action=Index}/{id?}");
            });

            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
            });
        }
    }
}
