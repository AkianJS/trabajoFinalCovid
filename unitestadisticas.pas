unit unitEstadisticas;

interface

uses
 Crt, unitArchivos;

procedure InicializarEst();
Procedure estEstado(var arch : tArchivo; var reg : tCliente);
Procedure estEstadoProvincia(var arch : tArchivo; var reg : tCliente; provincia : String);
Procedure RangoEtario(var arch : tArchivo; var reg: tCliente);
Procedure MetContagio(var arch : tArchivo; var reg : tCliente);

Var
  estActivos, estRecuperados, estFallecidos,
  menor18, menor50, mayor50,
  directo, transCom, desconocido, estPorProvincia : LongInt;

implementation

Procedure InicializarEst();
begin
  estActivos     := 0;
  estRecuperados := 0;
  estFallecidos  := 0;
  menor18 := 0;
  menor50 := 0;
  mayor50 := 0;
  directo     := 0;
  transCom    := 0;
  desconocido  := 0;
  estPorProvincia := 0;
end;

Procedure estEstado(var arch : tArchivo; var reg : tCliente);
Var		i : LongInt;
begin
  For i := 0 to filesize(arch)-1 do
    begin
    LeerArch(arch, reg, i);
    if reg.activo = true then
    begin
      if upcase(reg.estado) = 'ACTIVO' then
        estActivos := estActivos + 1
      else if upcase(reg.estado) = 'RECUPERADO' then
        estRecuperados := estRecuperados + 1
      else if upcase(reg.estado) = 'FALLECIDO' then
        estFallecidos := estFallecidos + 1;
        end;
    end;
end;

Procedure estEstadoProvincia(var arch : tArchivo; var reg : tCliente; provincia : String);
Var		i : LongInt;
begin
  For i := 0 to filesize(arch)-1 do
    begin
    LeerArch(arch, reg, i);
    if reg.activo = true then
    begin
      if upcase(provincia) = upcase(reg.provincia) then
        begin
      if upcase(reg.estado) = 'ACTIVO' then
        estActivos := estActivos + 1
      else if upcase(reg.estado) = 'RECUPERADO' then
        estRecuperados := estRecuperados + 1
      else if upcase(reg.estado) = 'FALLECIDO' then
        estFallecidos := estFallecidos + 1;
	end;
        end;
    end;
end;

Procedure RangoEtario(var arch : tArchivo; var reg: tCliente);
Var		i : LongInt;
begin
  For i := 0 to filesize(arch)-1 do
    begin
    LeerArch(arch, reg, i);
	  if reg.activo = true then
		begin
      if reg.edad < 18 then
        menor18 := menor18 +1
      else if (reg.edad >=18) and (reg.edad < 50) then
        menor50 := menor50 +1
      else if reg.edad >= 50 then
        mayor50 := mayor50 +1;
		end;
    end;
end;

Procedure MetContagio(var arch : tArchivo; var reg : tCliente);
Var		i : LongInt;
begin
  For i := 0 to filesize(arch)-1 do
    begin
      LeerArch(arch, reg, i);
      if reg.activo = true then
      begin
      if upcase(reg.formaDeCont) = 'DIRECTO' then
        directo := directo + 1
      else if upcase(reg.formaDeCont) = 'TRANSMISION COMUNITARIA' then
        transCom := transCom + 1
      else if upcase(reg.formaDeCont) = 'DESCONOCIDO' then
        desconocido := desconocido + +1;
        end;
    end;
end;

end.

