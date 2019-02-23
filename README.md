# neof
## F# support for neon .NET compiler suite

This project intends to provide initial support to F# language on Neo blockchain.
The idea is to extend existing neon .NET compiler (which currently supports C#) also to F# language.

WARNING: this project is alpha and has no current schedule (or big demands) to evolve quickly.
If you really need it, please give a hand to us, we can use our C# compiler knowledge to help you!

## Why F#?

Functional languages are promising for short, precise and secure codes, which is awesome!
Another advantage is that .NET basis should be nearly the same for Neo C# compiler, so *why not* do it? :)

## Creating a basic project

```
dotnet new sln -o FSNetCore
dotnet new console -lang F# -o src/App
dotnet sln add src/App/App.fsproj
```

Create `SmartContract.fs` file (framework file to be provided later):
```fs
namespace Neo.SmartContract.Framework
   module SmartContract =
      let nop w =
         w
      // Neo Devpack functions will be embedded here
```

Edit `App.fsproj` and add `SmartContract.fs`:
```xml
<ItemGroup>
  <Compile Include="SmartContract.fs" />
  <Compile Include="Program.fs" />
</ItemGroup>
```

Edit `Program.fs` with the following content (Simple One-Adder SmartContract using BigInteger)

```fs
open System
open Neo.SmartContract.Framework
open System.Numerics

(*
type OtherTestClass() =
   let mutable z = 0
   let Test1 k =
       k+1
   abstract member function1 : int -> int
   default u.function1(a : int) = z <- z + a; z

type OtherClass2() =
    inherit OtherTestClass()
    override u.function1(a: int) = a + 1
*)

module SmartContract =
//    [<EntryPoint>]  // will only work if Main has String[] parameter : let Main argv =  ...
      let Main (fname : String, argv : Object[]): BigInteger =
          let x: BigInteger = argv.[0] :?> BigInteger
          let one = new BigInteger(1)
          x + one // returns x + 1
```

Finally, to build on release: `dotnet build -c Release`

To generate avm, use this experimental shell script for conversor `ConvertTaskFS.sh`:
```sh
(cd /neo-compiler/neon/ && dotnet build)
cp /neo-compiler/neon/bin/Debug/netcoreapp2.0/neon.dll /tmp/FSNetCore2/src/App/bin/Release/netcoreapp2.2/
(cd bin/Release/netcoreapp2.2 && dotnet neon.dll App.dll)
```

It's building neon compiler too, and the reason is that a single change must be made on neon `Converter.cs` right now:
```cs
nm.inSmartContract = (m.Value.method.DeclaringType.BaseType.Name == "SmartContract") ||
                     (m.Value.method.DeclaringType.Name == "SmartContract");
```

This means that we will consider a SmartContract if it's included on Module `SmartContract`.
It's an experimental decision and can be changed on the future, with more discussions on F# community.

This process is currently generating this avm (`cat bin/Release/netcoreapp2.2/App.avm | xxd -p`):
```
52c56b6c766b00527ac46c766b51527ac46a51c300c3516157c693616c75
66
```

It's not yet generating correctly the BigInteger part, but it's on the way to go...
perhaps other simple stuff will work already, I don't know yet, feel free to test and contribute =)

MIT License

Copyleft 2019

NeoResearch Community
