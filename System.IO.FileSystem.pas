unit System.IO.FileSystem;

interface

uses
  System.SysUtils, System.IOUtils, System.Classes;

type
  TFileSystemInfo = class abstract
  private
    FFullPath: string;
    FOriginalPath: string;
    function GetAttributes: TFileAttributes; virtual;
  protected
    function GetFullPath: string; virtual;
    function GetFullName: string; virtual;
    function GetName: string; virtual;

    function GetCreationTime: TDateTime; virtual; abstract;
    function GetCreationTimeUtc: TDateTime; virtual; abstract;
    function GetLastWriteTimeUtc: TDateTime; virtual; abstract;

    /// <summary>
    /// Represents the fully qualified path of the directory or file.
    /// </summary>
    property FullPath: string read GetFullPath;
    /// <summary>
    /// The path originally specified by the user, whether relative or absolute.
    /// </summary>
    property OriginalPath: string read FOriginalPath;
  public
    /// <summary>
    /// Gets a value indicating whether the file or directory exists.
    /// </summary>
    function Exists: Boolean; virtual; abstract;

    property Attributes: TFileAttributes read GetAttributes;
    /// Gets or sets the creation time of the current file or directory.
    property CreationTime: TDateTime read GetCreationTime;
    /// Gets or sets the creation time, in coordinated universal time (UTC), of the current file or directory.
    property CreationTimeUtc: TDateTime read GetCreationTimeUtc;
    /// Gets the full path of the directory or file.
    property FullName: string read GetFullName;

    /// For files, gets the name of the file. For directories, gets the name of the last directory in the hierarchy if a hierarchy exists.
    /// Otherwise, the Name property gets the name of the directory.
    property Name: string read GetName;

    /// Gets or sets the time, in coordinated universal time (UTC), when the current file or directory was last written to.
    property LastWriteTimeUtc: TDateTime read GetLastWriteTimeUtc;
  end;

  TDirectoryInfo = class sealed(TFileSystemInfo)
  protected
    function GetCreationTime: TDateTime; override;
    function GetCreationTimeUtc: TDateTime; override;
    function GetLastWriteTimeUtc: TDateTime; override;
  public
    function Exists: Boolean; override;
  end;

  TFileInfo = class sealed(TFileSystemInfo)
  protected
    function GetCreationTime: TDateTime; override;
    function GetCreationTimeUtc: TDateTime; override;
    function GetLastWriteTimeUtc: TDateTime; override;
  public
    constructor Create(fullPath: string);

    function Exists: Boolean; override;
    //Gets the size, in bytes, of the current file.
    function Length: Int64;
  end;

implementation

{ TFileSystemInfo }
function TFileSystemInfo.GetAttributes: TFileAttributes;
begin
  Result := TPath.GetAttributes(FullPath);
end;

function TFileSystemInfo.GetFullName: string;
begin
  Result := TPath.GetFullPath(FullPath);
end;

function TFileSystemInfo.GetFullPath: string;
begin
  Result := FFullPath;
end;

function TFileSystemInfo.GetName: string;
begin
  Result := TPath.GetFileName(FullPath);
end;

{ TDirectoryInfo }

function TDirectoryInfo.Exists: Boolean;
begin
  Result := TDirectory.Exists(FullPath);
end;

function TDirectoryInfo.GetCreationTime: TDateTime;
begin
  Result := TDirectory.GetCreationTime(FullPath);
end;

function TDirectoryInfo.GetCreationTimeUtc: TDateTime;
begin
  Result := TDirectory.GetCreationTimeUtc(FullPath);
end;

function TDirectoryInfo.GetLastWriteTimeUtc: TDateTime;
begin
   Result := TDirectory.GetLastWriteTimeUtc(FullPath);
end;

{ TFileInfo }

constructor TFileInfo.Create(fullPath: string);
begin
  FFullPath := fullPath;
end;

function TFileInfo.Exists: Boolean;
begin
  Result := TFile.Exists(FullPath);
end;

function TFileInfo.GetCreationTime: TDateTime;
begin
  Result := TFile.GetCreationTime(FullPath);
end;

function TFileInfo.GetCreationTimeUtc: TDateTime;
begin
  Result := TFile.GetCreationTime(FullPath);
end;

function TFileInfo.GetLastWriteTimeUtc: TDateTime;
begin
  Result := TFile.GetLastWriteTimeUtc(FullPath);
end;

function TFileInfo.Length: Int64;
var
  Reader: TFileStream;
begin
  Reader := TFile.OpenRead(FullPath);
  try
    Result := Reader.Size;
  finally
    FreeAndNil(Reader);
  end;
end;

end.
