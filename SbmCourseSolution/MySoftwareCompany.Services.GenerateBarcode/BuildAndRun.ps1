$buildpath = "c:\tmp\MySoftwareCompany.Services.GenerateBarcode"
$imagename = "generatebarcodeimage"
$runningcontainername = "generatebarcodecontainer"

If(!(test-path $buildpath))
{
     New-Item -ItemType Directory -Force -Path $buildpath
}
else
{
     Remove-Item -LiteralPath $buildpath -Recurse
     New-Item -ItemType Directory -Force -Path $buildpath
}

dotnet publish  -c Release -o $buildpath

Copy-Item -Path DockerfileToDeploy -Destination $buildpath\Dockerfile

docker stop $runningcontainername
docker rm $runningcontainername
docker rmi $imagename

docker build -t $imagename -f $buildpath\Dockerfile $buildpath

Remove-Item -LiteralPath $buildpath -Recurse

docker container run -it  -p 5001:5001 --name $runningcontainername $imagename


