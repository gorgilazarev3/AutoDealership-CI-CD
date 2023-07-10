FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS BUILD
WORKDIR /source
COPY . .
RUN dir
RUN nuget restore
RUN msbuild "./AutoDealership/AutoDealership.csproj" /p:DeployOnBuild=true /p:PublishUrl="c:\publish" /p:WebPublishMethod=FileSystem /p:DeployDefaultTarget=WebPublish


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019
ARG source

WORKDIR /inetpub/wwwroot
COPY --from=build /publish ./
RUN icacls 'c:/inetpub/wwwroot' /grant 'Everyone:(OI)(CI)F'
RUN dir