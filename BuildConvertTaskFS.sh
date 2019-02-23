dotnet build -c Release
# considering that neo-compiler project is located on root filesystem / and project is on /tmp/FSNetCore2 folder
echo "Compatible mode is $COMPATIBLE"
(cd /neo-compiler/neon/ && dotnet build)
cp /neo-compiler/neon/bin/Debug/netcoreapp2.0/neon.dll /tmp/FSNetCore2/src/App/bin/Release/netcoreapp2.2/
(cd bin/Release/netcoreapp2.2 && dotnet neon.dll $COMPATIBLE App.dll)

