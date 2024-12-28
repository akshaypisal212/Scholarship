# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["scholarship/scholarship.csproj", "scholarship/"]
RUN dotnet restore "scholarship/scholarship.csproj"
COPY . .
WORKDIR "/src/scholarship"
RUN dotnet build "scholarship.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "scholarship.csproj" -c Release -o /app/publish

# Copy the build output to the base image
FROM base AS final
WORKDIR /app
#COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "scholarship.dll"]
