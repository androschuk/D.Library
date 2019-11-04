program Dictionary;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Sysutils, System.Generics.Dictionary, System.Generics.Collections;

procedure UseDictionary;
var
  dictionary: IDictionary<string, string>;
  item: TPair<string, string>;
begin
  Writeln('Print all environment variables...');

  dictionary := System.Generics.Dictionary.TDictionary<string, string>.Create;
  dictionary.Add('Key1', 'Value1');
  dictionary.Add('Key2', 'Value2');

  Writeln('Dictionary contains ' + dictionary.Count.ToString + ' elements');

  if not dictionary.ContainsKey('Key1') then
    raise Exception.Create('Dictionary not contain key1 item');


  Writeln('Dictionary items:');
  for item in dictionary do
    Writeln(item.Key + ' = ' + item.Value);
end;

begin
  try
    UseDictionary;

    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
