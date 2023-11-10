using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text.RegularExpressions;

var vfxFilePath = args.FirstOrDefault();

if (string.IsNullOrEmpty(vfxFilePath) || !File.Exists(vfxFilePath))
{
    Console.WriteLine("Please provide a path to a .vfx file as the first argument.");
    return -1;
}

var root = new DirectoryInfo(System.AppContext.BaseDirectory);
while (root!.Name != "compiler")
{
    root = root.Parent;
    if (root == null)
    {
        Console.WriteLine("Not within the 'compiler' folder.");
        return -1;
    }
}

var vfxc = Path.Combine(root.FullName, "bin/win64/vfxc.exe");
var vfxcompile = Path.Combine(root.FullName, "bin/win64/vfxcompile.exe");
var core = Path.Combine(root.FullName, "core");

vfxFilePath = Path.GetFullPath(vfxFilePath);
var shaders = Directory.GetParent(vfxFilePath);

Debug.Assert(File.Exists(vfxc), vfxc);
Debug.Assert(File.Exists(vfxcompile), "Mass compiler files are missing. Please install vfxcompile.exe & co.");
Debug.Assert(Directory.Exists(core), core);
Debug.Assert(shaders?.Name == "shaders", shaders?.Name);

// copy the shaders folder with full hierarchy to core
string? shaderFileName = null;
var shadersPath = Path.Combine(core, "shaders");

Directory.CreateDirectory(shadersPath);
foreach (var file in Directory.GetFiles(shaders!.FullName, "*.*", SearchOption.AllDirectories))
{
    var relativePath = Path.GetRelativePath(shaders.FullName, file);
    var destinationPath = Path.Combine(shadersPath, relativePath);

    if (destinationPath.EndsWith(".vfx"))
    {
        destinationPath = destinationPath[..^4] + ".shader";

        // Not the most reliable path equality check.
        if (file.Equals(vfxFilePath))
        {
            shaderFileName = destinationPath;
        };
    }

    Directory.CreateDirectory(Path.GetDirectoryName(destinationPath)!);
    File.Copy(file, destinationPath, true);
}

Debug.Assert(shaderFileName != null);

var startInfo = new ProcessStartInfo
{
    FileName = vfxcompile,
    ArgumentList = { shaderFileName, "-v" },
    WorkingDirectory = core,
    UseShellExecute = false,
    RedirectStandardOutput = true,
    RedirectStandardError = true,
};

foreach (var arg in args.Skip(1))
{
    startInfo.ArgumentList.Add(arg);
}

var compileProcess = Process.Start(startInfo);
if (compileProcess == null)
{
    Console.WriteLine("Failed to start vfxc.exe");
    return -1;
}

var vfxcOutput = new ConcurrentQueue<string>();
DataReceivedEventHandler eventHandler = (sender, e) =>
{
    if (e.Data is null)
        return;

    vfxcOutput.Enqueue(e.Data);
};
compileProcess.OutputDataReceived += eventHandler;
compileProcess.ErrorDataReceived += eventHandler;

compileProcess.BeginOutputReadLine();
compileProcess.BeginErrorReadLine();
compileProcess.WaitForExit();

var suceeded = false;
vfxFilePath = vfxFilePath.AsPosixPath();

foreach (var line in vfxcOutput)
{
    if (line.Contains("1 succeeded, 0 failed, 0 up-to-date"))
    {
        suceeded = true;
    }

    Console.WriteLine(line.Replace(shaderFileName, vfxFilePath)
                          .Replace(shaderFileName.AsPosixPath(), vfxFilePath));
}

Console.WriteLine($"{vfxFilePath} -- Done.");

if (suceeded)
{
    var compiledShaderPath = shaderFileName + "_c";
    Debug.Assert(File.Exists(compiledShaderPath), $"Compiled shader file {compiledShaderPath} is missing.");

    Console.WriteLine($"Resulting file: {compiledShaderPath}");
}

return compileProcess.ExitCode;

partial class Program
{
    [GeneratedRegex("#include\\s+\"(.+)\"")]
    private static partial Regex IncludeDirective();
}

public static class StringExtensions
{
    public static string AsPosixPath(this string path)
    {
        return path.Replace("\\", "/");
    }
}
