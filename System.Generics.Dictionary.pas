unit System.Generics.Dictionary;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Generics.Defaults;

type
  /// <remarks>
  /// Provides access to dictionary.
  /// </remarks>
  IDictionary<TKey,TValue> = interface
    /// <remarks>
    ///  Removes all items from the dictionary
    /// </remarks>
    procedure Clear;
    /// <remarks>
    /// Determines whether the IDictionary<TKey,TValue> contains an element with the specified key.
    /// </remarks>
    function ContainsKey(Key: TKey): Boolean;
    /// <remarks>
    /// Determines whether the IDictionary<TKey,TValue> contains an element with the specified value.
    /// </remarks>
    function ContainsValue(Value: TValue): Boolean;
    /// <remarks>
    ///  Adds an element with the provided key and value to the IDictionary<TKey,TValue>.
    /// </remarks>
    procedure Add(Key: TKey; Value: TValue);
    /// <remarks>
    /// Adds or replace an element with the provided key and value to the IDictionary<TKey,TValue>.
    /// </remarks>
    procedure AddOrSetValue(Key: TKey; Value: TValue);
    /// <remarks>
    ///
    /// </remarks>
    function TryGetValue(const Key: TKey; out Value: TValue): Boolean;
    /// <remarks>
    /// Returns an enumerator that iterates through a collection.
    /// </remarks>
    function GetEnumerator: System.Generics.Collections.TDictionary<TKey,TValue>.TPairEnumerator;

    /// <remarks>
    /// Gets the number of elements contained in the dictionary
    /// </remarks>
    function Count: Integer;

    /// <remarks>
    /// Gets the element with the specified key.
    /// </remarks>
    function GetItem(const Key: TKey): TValue;
    /// <remarks>
    ///  Sets the element with the specified key.
    /// </remarks>
    procedure SetItem(const Key: TKey; const Value: TValue);

    /// <remarks>
    ///  Gets or sets the element with the specified key.
    /// </remarks>
    property Items[const Key: TKey]: TValue read GetItem write SetItem; default;
  end;

  TDictionary<TKey,TValue> = class(TInterfacedObject, IDictionary<TKey,TValue>)
  private
    FDictionary: System.Generics.Collections.TDictionary<TKey,TValue>;
    function GetItem(const Key: TKey): TValue;
    procedure SetItem(const Key: TKey; const Value: TValue);
  public
    constructor Create(ACapacity: Integer = 0); overload;
    constructor Create(const AComparer: IEqualityComparer<TKey>); overload;
    constructor Create(ACapacity: Integer; const AComparer: IEqualityComparer<TKey>); overload;
    constructor Create(const Collection: TEnumerable<TPair<TKey,TValue>>); overload;
    constructor Create(const Collection: TEnumerable<TPair<TKey,TValue>>; const AComparer: IEqualityComparer<TKey>); overload;
    destructor Destroy; override;

    procedure Clear;
    function ContainsKey(Key: TKey): Boolean;
    function ContainsValue(Value: TValue): Boolean;
    procedure Add(Key: TKey; Value: TValue);
    procedure AddOrSetValue(Key: TKey; Value: TValue);
    function Count: Integer;

    function TryGetValue(const Key: TKey; out Value: TValue): Boolean;
    function GetEnumerator: System.Generics.Collections.TDictionary<TKey,TValue>.TPairEnumerator;
  end;

implementation

{ TDictionary<TKey, TValue> }

procedure TDictionary<TKey, TValue>.Add(Key: TKey; Value: TValue);
begin
  FDictionary.Add(key, value);
end;

procedure TDictionary<TKey, TValue>.AddOrSetValue(Key: TKey; Value: TValue);
begin
  FDictionary.AddOrSetValue(Key, Value);
end;

procedure TDictionary<TKey, TValue>.Clear;
begin
  FDictionary.Clear;
end;

function TDictionary<TKey, TValue>.ContainsKey(Key: TKey): Boolean;
begin
  Result := FDictionary.ContainsKey(Key);
end;

function TDictionary<TKey, TValue>.ContainsValue(Value: TValue): Boolean;
begin
  FDictionary.ContainsValue(Value)
end;

function TDictionary<TKey, TValue>.Count: Integer;
begin
  Result := FDictionary.Count;
end;

constructor TDictionary<TKey, TValue>.Create(ACapacity: Integer);
begin
  inherited Create;

  Create(ACapacity, Nil);
end;

constructor TDictionary<TKey, TValue>.Create(const AComparer: IEqualityComparer<TKey>);
begin
  inherited Create;

  FDictionary := System.Generics.Collections.TDictionary<TKey,TValue>.Create(AComparer);
end;

constructor TDictionary<TKey, TValue>.Create(ACapacity: Integer;
  const AComparer: IEqualityComparer<TKey>);
begin
  inherited Create;

  FDictionary := System.Generics.Collections.TDictionary<TKey,TValue>.Create(ACapacity, AComparer);
end;

constructor TDictionary<TKey, TValue>.Create(const Collection: TEnumerable<TPair<TKey, TValue>>);
begin
  inherited Create;

  Create(Collection, Nil);
end;

constructor TDictionary<TKey, TValue>.Create(const Collection: TEnumerable<TPair<TKey, TValue>>; const AComparer: IEqualityComparer<TKey>);
begin
  inherited Create;
  FDictionary := System.Generics.Collections.TDictionary<TKey,TValue>.Create(Collection, AComparer);
end;

destructor TDictionary<TKey, TValue>.Destroy;
begin
  FreeAndNIl(FDictionary);

  inherited;
end;

function TDictionary<TKey, TValue>.GetEnumerator: System.Generics.Collections.TDictionary<TKey, TValue>.TPairEnumerator;
begin
  Result := FDictionary.GetEnumerator;
end;

function TDictionary<TKey, TValue>.GetItem(const Key: TKey): TValue;
begin
  Result := FDictionary[Key];
end;

procedure TDictionary<TKey, TValue>.SetItem(const Key: TKey; const Value: TValue);
begin
  FDictionary[Key] := Value;
end;

function TDictionary<TKey, TValue>.TryGetValue(const Key: TKey; out Value: TValue): Boolean;
begin
  Result := FDictionary.TryGetValue(Key, Value);
end;

end.
