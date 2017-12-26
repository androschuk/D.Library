unit System.IO.DriveInfo;

interface

uses
  Winapi.Windows;

type
  /// <remarks>
  /// Constants source: <see cref="Winapi.Window"/>
  /// </remarks>
  TDriveType = (
    Unknown = DRIVE_UNKNOWN,
    NoRootDir = DRIVE_NO_ROOT_DIR,
    Remotable = DRIVE_REMOVABLE,
    Fixed = DRIVE_FIXED,
    Remote = DRIVE_REMOTE,
    CdRom = DRIVE_CDROM,
    RemDisk = DRIVE_RAMDISK
    );

  /// <summary>
  ///  Class helper for TDriveType
  /// </summary>
  TDriveTypeHelper = record helper for TDriveType
  public
    function ToString: string; inline;
  end;

  /// <summary>
  /// Provides access to information on the specified drive.
  /// </summary>
  IDriveInfo = interface
  ['{24983294-4727-4F52-9FCA-F1E5ABF7486F}']
    function GetVolumeLabel: WideString; safecall;
    procedure SetVolumeLabel(Value: WideString); safecall;
    /// <summary>
    ///  Indicates the amount of available free space on a drive, in bytes.
    /// </summary>
    function AvailableFreeSpace: Int64; safecall;
    /// <summary>
    ///  Gets the name of the file system, such as NTFS or FAT32.
    /// </summary>
    function DriveFormat: WideString; safecall;
    /// <summary>
    ///  Gets the drive type, such as CD-ROM, removable, network, or fixed.
    /// </summary>
    function DriveType: TDriveType; safecall;
    /// <summary>
    ///  Gets a value that indicates whether a drive is ready.
    /// </summary>
    function IsReady: Boolean; safecall;
    /// <summary>
    ///  Gets the name of a drive, such as C:\.
    /// </summary>
    function Name: WideString; safecall;
    /// <summary>
    ///  Gets the total amount of free space available on a drive, in bytes.
    /// </summary>
    function TotalFreeSpace: Int64; safecall;
    /// <summary>
    ///  Gets the total size of storage space on a drive, in bytes.
    /// </summary>
    function TotalSize: Int64; safecall;

    /// <summary>
    ///  Gets or sets the volume label of a drive.
    /// </summary>
    property VolumeLabel: WideString read GetVolumeLabel write SetVolumeLabel;
  end;

  TDriveInfo = class sealed (TInterfacedObject, IDriveInfo)
  private
    FDriveName: WideString;

    function GetVolumeLabel: WideString; safecall;
    procedure SetVolumeLabel(Value: WideString); safecall;
  public
    constructor Create(DriveName: string);

    class function GetDrives: TArray<IDriveInfo>;
    function AvailableFreeSpace: Int64; safecall;
    function DriveFormat: WideString; safecall;
    function DriveType: TDriveType; safecall;
    function IsReady: Boolean; safecall;
    function Name: WideString; safecall;
    function TotalFreeSpace: Int64; safecall;
    function TotalSize: Int64; safecall;
  end;

implementation

uses
  System.SysUtils, System.TypInfo, RTTI, Generics.Defaults;

{ TDriveInfo }

function TDriveInfo.AvailableFreeSpace: Int64;
var
  FreeAvailable : Int64;
  TotalSpace : Int64;
  TotalFree : Int64;
begin
  if GetDiskFreeSpaceEx(Pchar(Name), FreeAvailable, TotalSpace, @TotalFree) then
    Result := FreeAvailable
  else
    Result := 0;
end;

constructor TDriveInfo.Create(DriveName: string);
begin
  FDriveName := DriveName;
end;

function TDriveInfo.DriveFormat: WideString;
var
  NotUsed:     DWORD;
  VolumeFlags: DWORD;
  FileSystemName: array[0..MAX_PATH] of Char;
  VolumeSerialNumber: DWORD;
  Buf: array [0..MAX_PATH] of Char;
begin
  GetVolumeInformation(PWideChar(Name),
    Buf, SizeOf(Buf), @VolumeSerialNumber, NotUsed,
    VolumeFlags, FileSystemName, SizeOf(FileSystemName));

  SetString(Result, FileSystemName, StrLen(FileSystemName));   // Set return result
end;

function TDriveInfo.DriveType: TDriveType;
begin
    Result := TDriveType(GetDriveType(PWideChar(DRIVE_UNKNOWN)));
end;

class function TDriveInfo.GetDrives: TArray<IDriveInfo>;
var
  Drives: array[0..MAX_PATH] of WideChar;
  DriveName: PWideChar;
  DrivesSize: Integer;
const
  Size: Integer = MAX_PATH;
begin
    DrivesSize := GetLogicalDriveStrings(SizeOf(Drives), Drives);
    if DrivesSize = 0 then
      Exit; // no drive found, no further processing needed

    DriveName := Drives;
    while (DriveName^ <> #0) do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result)-1] := TDriveInfo.Create(StrPas(DriveName));

      Inc(DriveName, strlen(DriveName) + 1);
    end;
end;

function TDriveInfo.GetVolumeLabel: WideString;
var
  NotUsed:     DWORD;
  VolumeFlags: DWORD;
  VolumeSerialNumber: DWORD;
  Buf: array [0..MAX_PATH] of Char;
begin
  GetVolumeInformation(PWideChar(Name),
    Buf, SizeOf(Buf), @VolumeSerialNumber, NotUsed,
    VolumeFlags, nil, 0);

  SetString(Result, Buf, StrLen(Buf));   // Set return result
end;

function TDriveInfo.IsReady: Boolean;

  // Converts a drive letter into the integer drive #
  // required by DiskSize().
  function DOSDrive( const DriveName: String ): Integer;
  begin
    if (Length(DriveName) < 1) then
      Result := -1
    else
      Result := (Ord(UpCase(DriveName[1])) - 64);
  end;

var
  ErrMode: Word;
begin
  ErrMode := SetErrorMode(0);
  SetErrorMode(ErrMode Or SEM_FAILCRITICALERRORS Or SEM_NOOPENFILEERRORBOX);
  try
    Result := (DiskSize(DOSDrive(Name)) > -1);
  finally
    SetErrorMode(ErrMode);
  end;
end;

function TDriveInfo.Name: WideString;
begin
  Result := FDriveName;
end;

procedure TDriveInfo.SetVolumeLabel(Value: WideString);
begin
  SetVolumeLabelW(PWideChar(Name), PWideChar(Value));
end;

function TDriveInfo.TotalFreeSpace: Int64;
var
  FreeAvailable : Int64;
  TotalSpace : Int64;
  TotalFree : Int64;
begin
  if GetDiskFreeSpaceEx(Pchar(Name), FreeAvailable, TotalSpace, @TotalFree) then
    Result := TotalFree
  else
    Result := 0;
end;

function TDriveInfo.TotalSize: Int64;
var
  FreeAvailable : Int64;
  TotalSpace : Int64;
  TotalFree : Int64;
begin
  if GetDiskFreeSpaceEx(Pchar(Name), FreeAvailable, TotalSpace, @TotalFree) then
    Result := TotalSpace
  else
    Result := 0;
end;

{ TDriveTypeHelper }

function TDriveTypeHelper.ToString: string;
begin
  Result := TRttiEnumerationType.GetName(Self);
end;

end.
