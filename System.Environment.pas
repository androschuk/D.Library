unit System.Environment;

interface

uses
  System.SysUtils, WinApi.Windows, System.Generics.Dictionary,
  System.Generics.Defaults;

type
  /// <summary>
  ///   Provides information about, and means to manipulate, the current environmen
  /// </summary>
  TEnvironment = class sealed
  private
    class procedure PopulateVariables(EnvVar: PWideChar; DestDict: IDictionary<string, string>);
  public
    /// <summary>
    /// Retrieves all environment variable names and their values from the current process.
    /// <summary>
    class function GetEnvironmentVariable(Value: string): string;

    ///  <summary>
    ///  Creates, modifies, or deletes an environment variable stored in the current process.
    /// </summary>
    class procedure SetEnvironmentVariable(Name: string; Value: string);

    /// <summary>
    /// Retrieves environment variable value by name from the current process.
    /// </summary>
    class function GetEnvironmentVariables: IDictionary<string, string>;
  end;

implementation

{ TEnvironment }

class function TEnvironment.GetEnvironmentVariable(Value: string): string;
begin
  Result := System.SysUtils.GetEnvironmentVariable(Value);
end;

class function TEnvironment.GetEnvironmentVariables: IDictionary<string, string>;
var
  PStrings: PWideChar;
begin
  pStrings := GetEnvironmentStrings;

  if PStrings = Nil then
    raise EOutOfMemory.Create('');

  Result := TDictionary<string, string>.Create;
  try
    PopulateVariables(PStrings, Result);
  finally
    FreeEnvironmentStrings(PStrings);
  end;
end;

class procedure TEnvironment.PopulateVariables(EnvVar: PWideChar; DestDict: IDictionary<string, string>);
var
  block: string;
  value: string;
  key: string;
  dividerPos: Integer;
begin
  while envVar^ <> #0 do
  begin
    block := StrPas(envVar);
    inc(envVar, lStrLen(envVar) + 1);

    dividerPos := Pos('=', block);
    if dividerPos = -1 then
      Continue;

    key := block.Substring(0, dividerPos - 1).Trim;

    if key.IsEmpty then
      Continue;

    value := block.Substring(dividerPos, block.Length - dividerPos);

    try
      DestDict.Add(key, value);
    except
     on E: EListError do
       // Throw and catch intentionally to provide non-fatal notification about corrupted environment block
    end;
  end;
end;

class procedure TEnvironment.SetEnvironmentVariable(Name: string; Value: string);
var
  errorCode: Cardinal;
begin
  if Not WinApi.Windows.SetEnvironmentVariable(PWideChar(Name), PWideChar(Value)) then
  begin
    errorCode := GetLastError;

    case errorCode of
      ERROR_ENVVAR_NOT_FOUND:
        // Allow user to try to clear a environment variable
        Exit;
      ERROR_FILENAME_EXCED_RANGE:
        // The error message from Win32 is "The filename or extension is too long",
        // which is not accurate.
        raise EArgumentException.CreateFmt('Environment variable %s with value %s is too long', [Name, Value]);
      ERROR_NOT_ENOUGH_MEMORY,
      ERROR_NO_SYSTEM_RESOURCES:
        raise EOutOfMemory.Create(SysErrorMessage(errorCode));
      else
        raise EArgumentException.Create(SysErrorMessage(errorCode));
    end;
  end;
end;

end.
