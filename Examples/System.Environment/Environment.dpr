program Environment;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, System.Environment, System.Generics.Dictionary,
  Generics.Collections;

procedure PrintEnvironmentVariables;
var
  EnvVariables: IDictionary<string, string>;
  variable: TPair<string, string>;
begin
  Writeln('Print all environment variables...');

  EnvVariables := TEnvironment.GetEnvironmentVariables;

  Writeln('Environment Variables:');
  for variable in EnvVariables do
     Writeln(variable.Key + ' = ' + variable.Value);

  Writeln('');
end;

procedure PrintEnvironmentVariable(Key: string);
var
  value: string;
begin
   Writeln('Print single environment variable...');
   value := TEnvironment.GetEnvironmentVariable(key);
   Writeln(Key + ' = ' + value);
end;

procedure SetEnvironmentVariable(key, value: string);
begin
  Writeln('Set environment variable...');
  TEnvironment.SetEnvironmentVariable(key, value);

  Writeln('Check new variable value...');

  PrintEnvironmentVariable(key);

  Writeln('Cleanup variable value');
  TEnvironment.SetEnvironmentVariable(key, value);
end;

begin
  try
    PrintEnvironmentVariables;

    PrintEnvironmentVariable('Path');

    SetEnvironmentVariable('_custom-env-variable-key', '_custom-env-variable-value');

    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
