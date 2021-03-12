FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL maintainer="Mike Mesri"

COPY ["asset/*", "C:/Program Files/ServiceNow/"]

RUN powershell -Command \
  $ProgressPreference = 'SilentlyContinue' ; \
  Invoke-WebRequest -UseBasicParsing -Uri https://install.service-now.com/glide/distribution/builds/package/app-signed/mid/2021/03/01/mid.quebec-12-09-2020__patch1-02-18-2021_03-01-2021_1225.windows.x86-64.zip -OutFile 'C:\Program Files\ServiceNow\mid.zip' ; \
  Expand-Archive 'C:\Program Files\ServiceNow\mid.zip' -DestinationPath 'C:\Program Files\ServiceNow\' ; \
  Remove-Item 'C:\Program Files\ServiceNow\mid.zip'

EXPOSE 80 443

ENTRYPOINT [ "powershell" ]

CMD [ "& 'C:\\Program Files\\ServiceNow\\Initialize-MID.ps1' ; Get-Content 'C:\\Program Files\\ServiceNow\\agent\\logs\\agent0.log.0' -Wait -Tail 10 " ]
