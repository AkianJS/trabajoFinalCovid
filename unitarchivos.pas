unit unitArchivos;

interface

Uses
  Crt;

Type
  tCliente     = record
    nombre     : String[60];
    edad       : Byte;
    dni        : LongInt;
    domicilio  : String[60];
    ciudad     : String[60];
    provincia  : String[60];
    codigoPostal: String[60];
    celular    : LongInt;
    email      : String[60];
    fechaNac   : String[16];
    estado     : String[20];
    activo     : Boolean;
    formaDeCont: String[30]
  end;

  t_provincia= record
     denominacion: String[60];
     codigo_provincia: Integer;
     tel_de_contacto_por_covid19: Integer
	end;
  
  tEstadisticas = record
     id			: LongInt;
     dni		: LongInt;
     cod_prov	: LongInt;
     estado		: String[60];
     formaCont	: String[60]
    end; 
     

  tArchivo      = File of tCliente;
  tArchProv	 	= File of t_provincia;
  tArchEst		= File of tEstadisticas;
  	
VAR
 archivo         : tArchivo;
 archProvincia   : tArchProv;
 archEstadisticas: tArchEst;
 posicion        : LongInt;
 registro        : tCliente;
 regProvincia    : t_provincia;
 regEstadisticas : tEstadisticas;
 bol             : boolean;


Procedure Cargar(var reg : tCliente; var arch : tArchivo);
Procedure CargarProv(var reg : t_provincia; var arch : tArchProv);
Procedure CargarEstadisticas(var arch : tArchivo; var archProv : tArchProv; var archEst : tArchEst; var regEst : tEstadisticas);
Procedure GuardarEst(var arch : tArchEst; var reg : tEstadisticas; pos : LongInt);
Procedure Guardar(var arch : tArchivo; var reg : tCliente; var pos : LongInt);
Procedure LeerArch(var arch : tArchivo; var reg : tCliente; pos : LongInt);
Procedure LeerProvincia(var arch : tArchProv; var reg : t_provincia; pos : Integer);
Procedure LeerArchEst(var arch : tArchEst; var reg : tEstadisticas; pos : LongInt);
Procedure Listar(var arch : tArchivo; reg : tCliente);
Procedure ListarPorProv(var arch : tArchivo; reg : tCliente; nomProvincia : String);
Procedure ListarProvincias(var arch : tArchProv; reg : t_provincia);
Procedure ListarEstadisticas(var arch : tArchEst; var reg : tEstadisticas);
Procedure Mostrar (var arch : tArchivo; reg : tCliente; pos : LongInt);
Procedure MostrarProv(var arch : tArchProv; reg : t_provincia; pos : Integer);
Procedure MostrarEst(var arch : tArchEst; reg : tEstadisticas; pos : LongInt);
Procedure ordenBurbuja(var arch : tArchivo);
Procedure Burbuja2(var arch : tArchivo);
Function  BusquedaBinaria(var arch : tArchivo; buscado : LongInt): LongInt;

implementation

Procedure Guardar(var arch : tArchivo; var reg : tCliente; var pos : LongInt);
begin
  Seek(arch, pos);
  Write(arch, reg);
end;

Procedure LeerArch(var arch : tArchivo; var reg : tCliente; pos : LongInt);
begin
  Seek(arch, pos);
  Read(arch, reg);
end;

Procedure LeerProvincia(var arch : tArchProv; var reg : t_provincia; pos : Integer);
begin
  Seek(arch, pos);
  Read(arch, reg);
end;

Procedure LeerArchEst(var arch : tArchEst; var reg : tEstadisticas; pos : LongInt);
begin
Seek(arch, pos);
Read(arch, reg);
end;

Procedure GuardarEst(var arch : tArchEst; var reg : tEstadisticas; pos : LongInt);
begin
Seek(arch, pos);
Write(arch, reg);
end;

Procedure Cargar(var reg : tCliente; var arch : tArchivo);
Var				auxDni : LongInt;
begin
  Seek(arch, filesize(arch));
  With reg do
     begin
         Writeln('Ingrese el nombre del infectado');
         Readln(nombre);
          while nombre <> '' do
            begin
               Writeln('Ingrese DNI');
		   Repeat
               Readln(dni);
               Burbuja2(arch);
               auxDni:= BusquedaBinaria(arch, dni);
               if auxDni <> -1 then
               begin
               Writeln('El DNI ya existe, ingrese otro');
               end;
            Until auxDni = -1;   
               Writeln('Ingrese la edad');
               Readln(edad);
               Writeln('Ingrese domicilio (calle, numero y piso)');
               Readln(domicilio);
               Writeln('Ingrese la ciudad');
               Readln(ciudad);
               Writeln('Ingrese la provincia');
               Readln(Provincia);
               Writeln('Ingrese el codigo postal');
               Readln(codigoPostal);
               Writeln('Ingrese el numero de telefono');
               Readln(celular);
               Writeln('Ingrese su e-mail');
               Readln(email);
               Writeln('Ingrese fecha de nacimiento (dd/mm/a)');
               Readln(fechaNac);
               Writeln('Ingrese metodo de contagio (directo, transmision comunitaria, desconocido)');
               Readln(formaDeCont);
               activo := true;
               Writeln('Ingrese el estado (activo, recuperado, fallecido)');
               Readln(estado);
               Write(arch, reg);                             // Write(archivo, registro) guarda las variables en el registro
               Writeln('Ingrese el nombre del cliente');
               Readln(nombre);
             end;
      end;
end;

Procedure CargarProv(var reg : t_provincia; var arch : tArchProv);
begin
  Seek(arch, filesize(arch));
  With reg do
     begin
         Writeln('Ingrese denominacion de la Provincia');
         Readln(denominacion);
          while denominacion <> '' do
            begin
               Writeln('Codigo de la provincia');
               Readln(codigo_provincia);
               Writeln('Telefono contacto por Covid19');
               Readln(tel_de_contacto_por_covid19);
               Write(arch, reg);                             // Write(archivo, registro) guarda las variables en el registro
               Writeln('Ingrese el nombre del cliente');
               Readln(denominacion);
             end;
      end;
end;

Procedure CargarEstadisticas(var arch : tArchivo; var archProv : tArchProv; var archEst : tArchEst; var regEst : tEstadisticas);
Var		reg : tCliente;
		regProv : t_provincia;
		i, j	: LongInt;
begin
	i := 0;
	regEst.id := 0;
	while not EOF(arch) do
	begin
	  j := 0;
	  LeerArch(arch, reg, i);
	  regEst.id := i + 1;
	  regEst.dni := reg.dni;
	  repeat
	  LeerProvincia(archProv, regProv, j);
	  j := j +1;	  
	  until reg.provincia = regProv.denominacion;
	  regEst.cod_prov := regProv.codigo_provincia;
	  regEst.estado := reg.estado;
	  regEst.formaCont := reg.formaDeCont;
	  GuardarEst(archEst, regEst, i);
	  i := i + 1;
	end;
end;


// Proceso que muestra una lista de cada registro que puede volver al registro anterior o continuar dependiendo 
// la tecla que se presione
Procedure Listar(var arch : tArchivo; reg : tCliente);
Var       i            : LongInt;
          eleccion     : Char;
begin
  i := 0;
  eleccion := 'a';
  While not EOF(arch) and (eleccion <> #27) do
     begin
       ClrScr;
       LeerArch(arch, reg, i);                                 // Leemos desde el primer registro en el archivo
       if reg.activo then                                      // Condicional para que sólo muestre el registro si el campo activo es true
          begin
           Mostrar(arch, reg, i);
           Writeln('Activo: ', reg.activo);
           Writeln();
           Writeln('1: Anterior        2: Siguiente        ESC: Salir');
           repeat                                                  // Repeat para que la eleccion sea 1: anterior 2: siguiente 3 salir
           eleccion := Readkey;
           until (eleccion = '1') or (eleccion = '2') or (eleccion = #27);
             if (eleccion = '2') and (not EOF(arch))then
                i := i +1
             else if (eleccion = '1') and (i > 0) then
                i := i -1;
     end        // Final del if
       else if not reg.activo and (eleccion = '2') then
          i := i + 1
       else if not reg.activo and (eleccion = '1') and (i >= 1) then
          i := i - 1
       else 
          i := i + 1;
    end;
end;

Procedure ListarPorProv(var arch : tArchivo; reg : tCliente; nomProvincia : String);
Var       i            : LongInt;
          eleccion     : Char;
begin
  i := 0;
  eleccion := 'a';
  While not EOF(arch) and (eleccion <> #27) do
     begin
       ClrScr;
       LeerArch(arch, reg, i);                                 
       if (reg.activo) and (nomProvincia = reg.provincia) then                                      // Condicional para que sólo muestre el registro si el campo activo es true
          begin
           Mostrar(arch, reg, i);
           Writeln();
           Writeln('1: Anterior        2: Siguiente        ESC: Salir');
           repeat                                                  // Repeat para que la eleccion sea 1: anterior 2: siguiente 3 salir
           eleccion := Readkey;
           until (eleccion = '1') or (eleccion = '2') or (eleccion = #27);
             if (eleccion = '2') and (not EOF(arch))then
                i := i +1
             else if (eleccion = '1') and (i > 0) then
                i := i -1;
     end        // Final del if
       else if not reg.activo and (eleccion = '2') then
          i := i + 1
       else if not reg.activo and (eleccion = '1') and (i >= 1) then
          i := i - 1
       else 
          i := i + 1;
    end;
end;

Procedure ListarEstadisticas(var arch : tArchEst; var reg : tEstadisticas);
Var		i			: LongInt;
		eleccion 	: char;
begin
i := 0;
Writeln('1');
eleccion := 'a';
LeerArchEst(arch, reg, i);
  While not EOF(arch) and (eleccion <> #27) do
     begin
       ClrScr;                                 
	   MostrarEst(arch, reg, i);
	   Writeln();
	   Writeln('1: Anterior        2: Siguiente        ESC: Salir');
           repeat                                                  // Repeat para que la eleccion sea 1: anterior 2: siguiente 3 salir
           eleccion := Readkey;
           until (eleccion = '1') or (eleccion = '2') or (eleccion = #27);
             if (eleccion = '2') and (not EOF(arch))then
                i := i +1
             else if (eleccion = '1') and (i > 0) then
                i := i -1;	
	end;
end;

Procedure MostrarEst(var arch : tArchEst; reg : tEstadisticas; pos : LongInt);
begin
	LeerArchEst(arch, reg, pos);
	Writeln('ID: ', reg.id);
	Writeln('DNI: ', reg.dni);
	Writeln('Codigo de Provincia: ', reg.cod_prov);
	Writeln('Estado: ', reg.estado);
	Writeln('Forma de contagio: ', reg.formaCont);
end;

Procedure Mostrar (var arch : tArchivo; reg : tCliente; pos : LongInt);
 begin
   LeerArch(arch, reg, pos);
   Writeln('Nombre: ', reg.nombre);
   Writeln('DNI: ', reg.dni);
   Writeln('Domicilio: ', reg.domicilio);
   Writeln('Ciudad: ', reg.ciudad);
   Writeln('Provincia: ', reg.provincia);
   Writeln('Codigo Postal: ', reg.codigoPostal);
   Writeln('Celular: ', reg.celular);
   Writeln('E-mail: ', reg.email);
   Writeln('Estado: ', reg.estado);
   Writeln('Fecha de nacimiento: ', reg.fechaNac);
   Writeln('Forma de contagio: ', reg.formaDeCont);
 end;

Procedure ListarProvincias(var arch : tArchProv; reg : t_provincia);
Var       i            : LongInt;
          eleccion     : Char;
begin
  i := 0;
  eleccion := 'a';
  While not EOF(arch) and (eleccion <> #27) do
     begin
       ClrScr;
       LeerProvincia(arch, reg, i);                               
           MostrarProv(arch, reg, i);
           Writeln();
           Writeln('1: Anterior        2: Siguiente        ESC: Salir');
           repeat                                                 
           eleccion := Readkey;
           until (eleccion = '1') or (eleccion = '2') or (eleccion = #27);
           
             if (eleccion = '2') and (not EOF(arch))then
                i := i +1
             else if (eleccion = '1') and (i > 0) then
                i := i -1
     end;
end;

Procedure MostrarProv(var arch : tArchProv; reg : t_provincia; pos : Integer);
begin
  LeerProvincia(arch, reg, pos);
  Writeln('Denominacion: ', reg.denominacion);
  Writeln('Codigo de Provincia: ', reg.codigo_provincia);
  Writeln('Numero de Contacto por Covid19: ', reg.tel_de_contacto_por_covid19);
end;

Procedure ordenBurbuja(var arch : tArchivo);
Var       reg1, reg2 : tCliente;
          lim, i, j : LongInt;
 begin
   lim := filesize(arch)-1;
     For i := 1 to lim -1 do
       For j := 0 to lim - i do
         begin
           LeerArch(arch, reg1, j);
           LeerArch(arch, reg2, j+1);
             If reg1.nombre > reg2.nombre then
                begin
                  Seek(arch, j+1);
                  Write(arch, reg1);
                  Seek(arch, j);
                  Write(arch, reg2);
                end;
         end;
 end;

Procedure Burbuja2(var arch : tArchivo); // Ordenamiento por DNI para la búsqueda
Var       reg1, reg2 : tCliente;
          lim, i, j : LongInt;
 begin
   lim := filesize(arch)-1;
     For i := 1 to lim -1 do
       For j := 0 to lim - i do
         begin
           LeerArch(arch, reg1, j);
           LeerArch(arch, reg2, j+1);
             If reg1.dni > reg2.dni then
                begin
                  Seek(arch, j+1);
                  Write(arch, reg1);
                  Seek(arch, j);
                  Write(arch, reg2);
                end;
         end;
 end;

Function BusquedaBinaria(var arch : tArchivo; buscado : LongInt): LongInt;
Var       reg : tCliente;
          pri, med, ult, pos : LongInt;
          encontrado : boolean;
begin
  encontrado := false;
  pri := 0;
  ult := filesize(arch)-1;
  pos := -1;
    While (pos = -1) and (pri <= ult) do
    begin
       med := (pri + ult) div 2;
       LeerArch(arch, reg, med);
       if reg.dni = buscado then
          begin
            encontrado := true;
            pos := med;
          end
           else
             if reg.dni > buscado then
                ult := med-1
                  else
                    pri := med + 1;
       end;
       
    if encontrado then
       BusquedaBinaria := pos
    else
       BusquedaBinaria := -1;
end;

END.

