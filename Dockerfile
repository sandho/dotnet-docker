FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["docker-dotnetcore-api.csproj", "."]
RUN dotnet restore "docker-dotnetcore-api.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "docker-dotnetcore-api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "docker-dotnetcore-api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "docker-dotnetcore-api.dll"]
# 5107