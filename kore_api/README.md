# Task Manager API

Task Managing RESTful API built with ASP.NET Core 2.1

* ASP.NET Core 2.1
* Entity Framework Core
* AWS Cognito
* EntityFrameworkCore.MySql
* Swagger UI

### Prerequisites
* [Visual Studio 2017/2019](https://visualstudio.microsoft.com/downloads/)
* [XAMMP](https://www.apachefriends.org/index.html)

### Installing

1. Clone or download this project
2. Navigate to kore_api.sln and open it
3. Navigate to Build - Rebuild Solution
4. Setup a MySql database server with XAMMP with username: root and password: password
5. Press F5 to launch the sln
6. Navigate to http://localhost:56203/swagger/ for API documentation and testing

### API Testing
- Production API documentation with testing available [HERE](https://w4c7snxw32.execute-api.us-east-2.amazonaws.com/Prod/swagger/)

- Local API documentation with testing available at [HERE](http://localhost:56203/swagger/) after launching the sln

- Sign In

![](../project-files/swagger1.png)

- Copy Bearer token

![](../project-files/swagger2.png)

- Click on Authorize button at the top and enter in Bearer followed by a space and then the token

![](../project-files/swagger3.png)

- All endpoints will now work once the authorization steps have been completed

## Deployment
* AWS Serverless [HERE](https://w4c7snxw32.execute-api.us-east-2.amazonaws.com/Prod/swagger/)

## Built With
* .NET Core Web API (Back-end)
