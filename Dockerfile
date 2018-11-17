FROM microsoft/dotnet:2.1-sdk-alpine AS build-env
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# build frontend
FROM node:8.12-alpine AS frontend-build-env
WORKDIR /app
COPY ./todolist-client ./
RUN yarn && npx webpack -o dist/bundle.js

# build runtime image
FROM microsoft/dotnet:2.1-aspnetcore-runtime-alpine
WORKDIR /app
COPY --from=frontend-build-env /app/dist ./wwwroot/dist
COPY --from=build-env /app/out .
ENV ASPNETCORE_URLS="http://*:80"
ENTRYPOINT ["dotnet", "/app/TodoApi.dll"]
