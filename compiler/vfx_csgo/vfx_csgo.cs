using System.Diagnostics;
using System.Text.RegularExpressions;

var vfxFilePath = args.FirstOrDefault();

if (string.IsNullOrEmpty(vfxFilePath) || !File.Exists(vfxFilePath))
{
    Console.WriteLine("Please provide a path to a .vfx file.");
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
var core = Path.Combine(root.FullName, "core");

vfxFilePath = Path.GetFullPath(vfxFilePath);
var shaders = Directory.GetParent(vfxFilePath);

Debug.Assert(File.Exists(vfxc), vfxc);
Debug.Assert(Directory.Exists(core), core);
Debug.Assert(shaders?.Name == "shaders", shaders?.Name);

// copy the shaders folder with full hierarchy to core
string? shaderFileName = null;
var shadersPath = Path.Combine(core, "shaders");

Directory.CreateDirectory(shadersPath);
foreach (var file in Directory.GetFiles(shaders!.FullName, "*.*", SearchOption.AllDirectories))
{
    bool fixupIncludes = false;
    var relativePath = Path.GetRelativePath(shaders.FullName, file);
    var destinationPath = Path.Combine(shadersPath, relativePath);

    if (destinationPath.EndsWith(".vfx"))
    {
        destinationPath = destinationPath[..^4] + ".shader";
        fixupIncludes = false;

        if (file.Equals(vfxFilePath))
        {
            //fixupIncludes = true;
            shaderFileName = destinationPath;
        };
    }

    Directory.CreateDirectory(Path.GetDirectoryName(destinationPath)!);
    File.Copy(file, destinationPath, true);

    if (fixupIncludes)
    {
        var lines = File.ReadAllLines(destinationPath);
        for (int i = 0; i < lines.Length; i++)
        {
            var match = IncludeDirective().Match(lines[i]);
            if (match.Success)
            {
                var includePath = match.Groups[1].Value;

                if (includePath.EndsWith(".fxc"))
                {
                    continue;
                }

                var fullPath = Path.GetFullPath(Path.Combine(shadersPath, includePath));

                // substitute relative include with full path
                lines[i] = lines[i].Replace(includePath, fullPath);
            }
        }

        File.WriteAllLines(destinationPath, lines);
    }
}

Debug.Assert(shaderFileName != null);

var startInfo = new ProcessStartInfo
{
    FileName = vfxc,
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

compileProcess.OutputDataReceived += (sender, e) => Console.WriteLine(e.Data);
compileProcess.ErrorDataReceived += (sender, e) => Console.Error.WriteLine(e.Data);
compileProcess.BeginOutputReadLine();
compileProcess.BeginErrorReadLine();
compileProcess.WaitForExit();
return compileProcess.ExitCode;

partial class Program
{
    [GeneratedRegex("#include\\s+\"(.+)\"")]
    private static partial Regex IncludeDirective();
}
