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
using System.Reflection;
using System.IO;

namespace kore_api
{
    public class Startup
    {
        public const string AppS3BucketKey = "AppS3Bucket";

        public string ConnectionString;
		public string SwaggerPath;

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public static IConfiguration Configuration { get; private set; }

        // This method gets called by the runtime. Use this method to add services to the container
        public void ConfigureServices(IServiceCollection services)
        {
			
			services.AddAuthorization(options =>
			{
				//Policies for Cognito roles
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

            services.AddCors();

            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new Info { Title = "Task Manager API", Version = "v1" });
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
                // Set the comments path for the Swagger JSON and UI.
                var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
                var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
                c.IncludeXmlComments(xmlPath);
            });

            if (Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Development")
            {
                //this.ConnectionString = "server=localhost;port=3306;user=root;password=password;database=koredb";
                this.ConnectionString = "server=koretaskmanagerrdsinstance.cya4cpibjenz.us-east-2.rds.amazonaws.com;port=3306;user=koreadmin;password=koressd2019;database=koredb";
            }
            else if (Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Production")
            {
                this.ConnectionString = "server=koretaskmanagerrdsinstance.cya4cpibjenz.us-east-2.rds.amazonaws.com;port=3306;user=koreadmin;password=koressd2019;database=koredb";
            }

            services.AddDbContext<koredbContext>(options =>
            options.UseMySQL(ConnectionString));

            //Repos
            services.AddScoped<IAccountsRepository, AccountsRespository>();
            services.AddScoped<ITasksRepository, TasksRepository>();
			services.AddScoped<IUserRepository, UserRepository>();
            services.AddScoped<IFilesRepository, FilesRepository>();
            services.AddScoped<IOrganizationRepository, OrganizationRepository>();

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

            app.UseCors(
                options => options.WithOrigins("http://example.com").AllowAnyMethod()
            );

            app.UseMvc(routes =>
            {
                routes.MapRoute("default", "{controller=Home}/{action=Index}/{id?}");
            });

			if (Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Development")
			{
				this.SwaggerPath = "/swagger/v1/swagger.json";
			}
			else if (Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Production")
			{
				this.SwaggerPath = "/Prod/swagger/v1/swagger.json";
			}

			app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint(SwaggerPath, "My API V1");
            });
        }
    }
}
