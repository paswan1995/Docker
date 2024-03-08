FROM mcr.microsoft.com/dotnet/sdk:7.0
LABEL author="anil" learning="docker" organization="qt"
ADD https://github.com/nopSolutions/nopCommerce/releases/download/release-4.60.6/nopCommerce_4.60.6_NoSource_linux_x64.zip /nop/nopCommerce_4.60.6_NoSource_linux_x64.zip
WORKDIR /nop
RUN apt update && apt install unzip && \
    unzip /nop/nopCommerce_4.60.6_NoSource_linux_x64.zip && \
    mkdir /nop/bin && mkdir /nop/logs
EXPOSE 5000
ENV ASPNETCORE_URLS="http://0.0.0.0:5000"
CMD [ "dotnet", "Nop.Web.dll" ]
