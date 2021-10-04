unit unitProcesos;

interface

uses
  unitArchivos, Crt, unitEstadisticas;

Procedure ComprobarApertura(var arch : tArchivo; ruta : String);
Procedure ComprobarAperturaProvincia(var arch : tArchProv; ruta : String);
Procedure ComprobarAperturaEstadistica(var arch : tArchEst; ruta : String);
Procedure Menu();
Procedure Abmc();
Procedure Alta(var arch : tArchivo; var reg : tCliente);
Procedure Baja(var arch : tArchivo; var reg : tCliente);
Procedure Modificar();
Procedure elegirMod(var arch : tArchivo; var reg : tCliente; pos : LongInt);
Procedure elegirMod2(var arch : tArchivo; var reg : tCliente; pos : LongInt);
Procedure EstadisticasMenu(var arch : tArchivo; reg : tCliente);
Procedure Agregar(var arch : tArchivo; var archProv : tArchProv; var reg : tCliente; var regProv : t_provincia);
Procedure ListadoOrdenado(var arch : tArchivo; reg : tCliente);

implementation

const
 Infectados 	= '.\Archivo_Cliente.dat';
 ProvinciaArch  = '.\Archivo_Provincia.dat';
 EstadistArch   = '.\Archivo_Estadisticas.dat';	

Procedure ComprobarApertura(var arch : tArchivo; ruta : String);
begin
  Assign(arch, ruta);
  {$I-}
  Reset(arch);
  {$I+}
  if IoResult <> 0 then
     Rewrite(arch);
end;

Procedure ComprobarAperturaProvincia(var arch : tArchProv; ruta : String);
begin
  Assign(arch, ruta);
  {$I-}
  Reset(arch);
  {$I+}
  if IoResult <> 0 then
     Rewrite(arch);
end;

Procedure ComprobarAperturaEstadistica(var arch : tArchEst; ruta : String);
begin
  Assign(arch, ruta);
  {$I-}
  Reset(arch);
  {$I+}
  if IoResult <> 0 then
     Rewrite(arch);
end;

Procedure EstadisticasMenu(var arch : tArchivo; reg : tCliente);
Var		opcion  : char;
		total, i	: LongInt;
		prov	: String;
begin
  total := 0;
  for i := 0 to filesize(arch) -1 do
  begin
  LeerArch(arch, reg, i);
  if reg.activo = true then
  total := total + 1;
  end;
  Writeln('Que estadisticas desea ver?');
  Writeln('1: Estado (activo, recuperado, fallecido) en el pais');
  Writeln('2: Estado (activo, recuperado, fallecido) por provincia');
  Writeln('3: Formas de contagio');
  Writeln('4: Rango etario');
  Writeln();
  Writeln('ESC: Salir');
  repeat
  opcion := Readkey;
  until (opcion = '1') or (opcion = '2') or (opcion = '3') or (opcion = '4') or (opcion = #27);
  ClrScr;
  Case opcion of
	'1': begin
		  InicializarEst;
		  estEstado(arch, reg);
		  Writeln('La cantidad de casos activos en el pais es: ', estActivos);
		  if estActivos > 0 then 
		    Writeln('Y representa el ', (estActivos*100)/total:3:2, ' % de los ingresados');
		    Writeln();
		  Writeln('La cantidad de recuperados en el pais es: ', estRecuperados);
		  if estRecuperados > 0 then 
		    Writeln('Y representa el ', (estRecuperados*100)/total:3:2, ' % de los ingresados');
		    Writeln();
		  Writeln('La cantidad de fallecidos en el pais es: ', estFallecidos);
		  if estFallecidos > 0 then 
		    Writeln('Y representa el ', (estFallecidos*100)/total:3:2, ' % de los ingresados');
		end;
	'2': begin
		  InicializarEst;
		  Writeln('Ingrese la provincia');
		  Readln(prov);
		  estEstadoProvincia(arch, reg, prov);
		  Writeln('La cantidad de casos activos en el pais es: ', estActivos);
		  if estActivos > 0 then 
		    Writeln('Y representa el ', (estActivos*100)/total:3:2, ' % de los ingresados');
		    Writeln();
		  Writeln('La cantidad de recuperados en el pais es: ', estRecuperados);
		  if estRecuperados > 0 then 
		    Writeln('Y representa el ', (estRecuperados*100)/total:3:2, ' % de los ingresados');
		    Writeln();
		  Writeln('La cantidad de fallecidos en el pais es: ', estFallecidos);
		  if estFallecidos > 0 then 
		    Writeln('Y representa el ', (estFallecidos*100)/total:3:2, ' % de los ingresados');
		end;
	'3': begin
		  InicializarEst;
		  MetContagio(arch, reg);
		  Writeln('La cantidad de contagios directos en el pais es de: ', directo);
		  if directo > 0 then
			Writeln('Y representa el ', (directo*100)/total:3:2, ' % de los ingresados');
			Writeln();
		  Writeln('La cantidad de contagios por transmision comunitaria en el pais es de: ', transCom);
		  if transCom > 0 then
			Writeln('Y representa el ', (transCom*100)/total:3:2, ' % de los ingresados');
			Writeln();
		  Writeln('La cantidad de contagios por metodo desconocido en el pais es de: ', desconocido);
		  if desconocido > 0 then
			Writeln('Y representa el ', (desconocido*100)/total:3:2, ' % de los ingresados');					  
		end;
	'4': begin
		  InicializarEst;
		  RangoEtario(arch, reg);
		  Writeln('La cantidad de personas menor a 18 anios es: ', menor18);
		  if menor18 > 0 then
			Writeln('Y representa el ', (menor18*100)/total:3:2, ' % de los ingresados');
			Writeln();			
		  Writeln('La cantidad de personas entre 18 y 50 anios es: ', menor50);
		  if menor50 > 0 then
			Writeln('Y representa el ', (menor50*100)/total:3:2, ' % de los ingresados');
			Writeln();
		  Writeln('La cantidad de personas mayores a 49 anios es: ', mayor50);			
		  if mayor50 > 0 then
			Writeln('Y representa el ', (mayor50*100)/total:3:2, ' % de los ingresados');						
		end;
	end;
	Writeln();
	Writeln('Presione una tecla para volver');
	Readkey;
end;

Procedure Alta(var arch : tArchivo; var reg : tCliente);
Var       dni, pos : LongInt;
          opcion : char;
begin
  ClrScr;
  Writeln('Digite el DNI que busca');
  Readln(dni);
  pos := BusquedaBinaria(archivo, dni);
  if pos <> -1 then
     begin
        LeerArch(arch, reg, pos);
        if  reg.activo then
        begin
           Writeln('La persona ya ha sido dada de alta');
           Delay(1000);
           end
        else
        begin
           ClrScr;
           Writeln();
           Mostrar(arch, reg, pos);
           Writeln();
           Writeln('Activo: ', reg.activo);
           Writeln('Desea dar de alta?');
           Writeln('1: si / 2: no');
             repeat
             opcion := readkey();
             until (opcion = '1') or (opcion = '2');
               if opcion = '1' then
                  begin
                  reg.activo := true;
                  Guardar(arch, reg, pos);
                  Writeln('Operacion exitosa');
                  Delay(1000);
                  end
               else
                 Writeln('Volviendo al menu ABMC');
                 Delay(1000);
                 Abmc();
           end;
     end
  else
	  begin
		Writeln('Numero de documento no encontrado');
		Delay (1000);
		Abmc;
	  end;  
end;

Procedure Baja(var arch : tArchivo; var reg : tCliente);
Var       dni, pos : LongInt;
          opcion : char;
begin
  ClrScr;
  Writeln('Digite el DNI que busca');
  Readln(dni);
  pos := BusquedaBinaria(archivo, dni);
  if pos <> -1 then
     begin
        LeerArch(arch, reg, pos);
        if not reg.activo then
        begin
           Writeln('La persona ya ha sido dada de baja');
           Delay(1000);
        end
        else
        begin
           ClrScr;
           Writeln();
           Mostrar(arch, reg, pos);
           Writeln('Activo: ', reg.activo);
           Writeln();
           Writeln('Desea dar de baja?');
           Writeln('1: si / 2: no');
             repeat
             opcion := readkey();
             until (opcion = '1') or (opcion = '2');
               if opcion = '1' then
                  begin
                  reg.activo := false;
                  Guardar(archivo, registro, posicion);
                  Writeln('Operacion exitosa');
                  Delay(1000);
                  end
               else
                 Writeln('Volviendo al menu ABMC');
                 Delay(1000);
                 Abmc();
           end;
     end
  else
	  begin
		Writeln('Numero de documento no encontrado');
		Delay (1000);
		Abmc;
	  end;
end;

Procedure Modificar();
Var       dni, pos : LongInt;
begin
  ClrScr;
  Writeln('Digite el DNI que busca');
  Readln(dni);
  pos := BusquedaBinaria(archivo, dni);
  if pos <> -1 then
     begin
       elegirMod(archivo, registro, pos);
     end
  else
    Writeln('Numero de documento no encontrado');
    Delay (1000);
    Abmc;
end;

Procedure elegirMod(var arch : tArchivo; var reg : tCliente; pos : LongInt);
Var       eleccion : char;
begin
   ClrScr;
   Writeln('Que desea modificar?');
   Writeln();
   Writeln('1: Nombre    2: Edad          3: DNI     4: Domicilio     5: Ciudad');
   Writeln('6: Provincia 7: Codigo Postal 8: Celular 9: Siguiente     ESC: Salir');
   Repeat
   eleccion := Readkey;
   until (eleccion = '1') or (eleccion = '2') or (eleccion = '3') or (eleccion = '4') or (eleccion = '5') or 
		 (eleccion = '6') or (eleccion = '7') or (eleccion = '8') or (eleccion = '9') or (eleccion = #27);

          Case eleccion of
       '1': begin
            LeerArch(arch, reg, pos);
            Writeln('Ingrese el nombre');
            Readln(reg.nombre);
            Guardar(arch, reg, pos);
            Writeln('Operacion exitosa');
       end;
       '2': begin
             LeerArch(arch, reg, pos);
             Writeln('Ingrese la edad');
             Readln(reg.edad);
             Writeln();
             Guardar(arch, reg, pos);
             Writeln('Operacion exitosa');
            end;
       '3': begin
             LeerArch(arch, reg, pos);
             Writeln('Ingrese el DNI');
             Readln(reg.dni);
             Writeln();
             Guardar(arch, reg, pos);
             Writeln('Operacion exitosa');
            end;
       '4': begin
             LeerArch(arch, reg, pos);
             Writeln('Ingrese el domicilio');
             Readln(reg.domicilio);
             Writeln();
             Guardar(arch, reg, pos);
             Writeln('Operacion exitosa');
            end;
       '5': begin
             LeerArch(arch, reg, pos);
             Writeln('Ingrese la ciudad');
             Readln(reg.ciudad);
             Writeln();
             Guardar(arch, reg, pos);
             Writeln('Operacion exitosa');
            end;
       '6': begin
             LeerArch(arch, reg, pos);
             Writeln('Ingrese la provincia');
             Readln(reg.provincia);
             Writeln();
             Guardar(arch, reg, pos);
             Writeln('Operacion exitosa');
            end;
       '7': begin
             LeerArch(arch, reg, pos);
             Writeln('Ingrese el codigo postal');
             Readln(reg.codigoPostal);
             Writeln();
             Guardar(arch, reg, pos);
             Writeln('Operacion exitosa');
            end;
       '8': begin
             LeerArch(arch, reg, pos);
             Writeln('Ingrese el numero de celular');
             Readln(reg.celular);
             Writeln();
             Guardar(arch, reg, pos);
             Writeln('Operacion exitosa');
            end;
       '9': begin
             elegirMod2(archivo, registro, pos);
            end;
        #27: Abmc();    
       end;
end;

Procedure elegirMod2(var arch : tArchivo; var reg : tCliente; pos : LongInt);
Var        eleccion : Char;
begin
   ClrScr;
   Writeln('Que desea modificar?');
   Writeln();
   Writeln('1: E-mail    2: Fecha de nacimiento    3: Forma de contagio    4: Salir    ESC: volver');
       Repeat
       eleccion := Readkey;
       until (eleccion = '1') or (eleccion = '2') or (eleccion = '3') or (eleccion = #27);
       case eleccion of
       '1': begin
            LeerArch(arch, reg, pos);
            Writeln('Ingrese el e-mail');
            Readln(reg.email);
            Writeln();
            Guardar(arch, reg, pos);
            Writeln('Operacion exitosa');
       end;
       '2': begin
             LeerArch(arch, reg, pos);
             Writeln('Ingrese la fecha de nacimiento');
             Readln(reg.fechaNac);
             Writeln();
             Guardar(arch, reg, pos);
             Writeln('Operacion exitosa');
            end;
       '3': begin
             LeerArch(arch, reg, pos);
             Writeln('Ingrese el metodo de contagio');
             Readln(reg.formaDeCont);
             Writeln();
             Guardar(arch, reg, pos);
             Writeln('Operacion exitosa');
            end;
       '4': Abmc();
       #27: begin
             elegirMod(archivo, registro, posicion);
            end;
       end;
end;

Procedure Consultar(var arch : tArchivo; reg : tCliente);
Var       pos, dni : LongInt;
          opcion : char;
begin
  ClrScr;
  Writeln('Ingrese el DNI a consultar');
  Readln(dni);
  pos := BusquedaBinaria(arch, dni);
    if pos <> -1 then
       begin
          ClrScr;
          Mostrar(arch, reg, pos);
          Writeln();
          Writeln('Presione ESC para volver al menu');
          repeat
            opcion := Readkey;
          until opcion = #27;
       end
    else
    begin
      Writeln('Documento no encontrado');
      Delay(1000);
    end;
end;

Procedure Abmc();
Var       opcion : char;
begin
  ClrScr;
  Writeln('Digite la opcion deseada');
  Writeln();
  Writeln('1: Alta');
  Writeln('2: Baja');
  Writeln('3: Modificar');
  Writeln('4: Consultar');
  Writeln();
  Writeln('ESC: Volver al menu principal');
    Repeat
    opcion := readkey;
    until (opcion = '1') or (opcion = '2') or (opcion = '3') or (opcion = '4') or (opcion = #27);
	Burbuja2(archivo); // Ordenar Por DNI para ser buscado mediante Bbin
    case opcion of
    '1': Alta(archivo, registro);
    '2': Baja(archivo, registro);
    '3': Modificar();
    '4': Consultar(archivo, registro);
    end;
end;

Procedure Agregar(var arch : tArchivo; var archProv : tArchProv; var reg : tCliente; var regProv : t_provincia);
Var		opcion : char;
Begin
  ClrScr;
  Writeln('Digite la opcion deseada');
  Writeln();
  Writeln('1: Agregar infectados');
  Writeln('2: Agregar provincias');
  Writeln('ESC: Salir');
  repeat 
  opcion := Readkey;
  until (opcion = '1') or (opcion = '2') or (opcion = #27);
	case opcion of
	'1': begin
		ClrScr;
		ComprobarApertura(arch, infectados);
		Cargar(reg, arch);
		Writeln('Operacion exitosa');
		Close(arch);
		Delay(1000);
	end;
	'2': begin
		ClrScr;
		ComprobarAperturaProvincia(archProv, ProvinciaArch);
		CargarProv(regProv, archProv);
		Writeln('Operacion exitosa');
		Close(archProv);
		Delay(1000);
		end;
	end; 
end;

Procedure ListadoOrdenado(var arch : tArchivo; reg : tCliente);
Var		opcion : char;
		nomProv: String;
begin
	Writeln('1: Para ver el listado del pais');
	Writeln('2: Para ver el listado por provincia');
	Writeln('3: Listado de Provincias');
	Writeln('4: Listado de Archivo Estadisticas');
	Writeln();
	Writeln('ESC: Salir');
	repeat
	opcion := Readkey
	until (opcion = '1') or (opcion = '2') or (opcion = '3') or (opcion = '4') or (opcion = #27);
	case opcion of
	'1': begin
		ClrScr;
		ComprobarApertura(arch, infectados);
		OrdenBurbuja(arch);
		Listar(arch, reg);
		Close(arch);
		end;
	'2': begin	
		ClrScr;
		ComprobarApertura(arch, infectados);
		OrdenBurbuja(arch);
		Writeln('Ingrese provincia');
		Readln(nomProv);
		ListarPorProv(arch, reg, nomProv);
		Close(archivo);
		end;
	'4': begin
		ComprobarApertura(arch, infectados);
		ComprobarAperturaProvincia(archProvincia, ProvinciaArch);
		ComprobarAperturaEstadistica(archEstadisticas, EstadistArch);
		CargarEstadisticas(arch, archProvincia, archEstadisticas, regEstadisticas);
		ListarEstadisticas(archEstadisticas, regEstadisticas);
		Close(arch);
		Close(archEstadisticas);
		Close(archProvincia);
		end;
	'3': begin
		 ClrScr;
		 ComprobarAperturaProvincia(archProvincia, ProvinciaArch);
		 ListarProvincias(archProvincia, regProvincia);
		 Close(archProvincia);	
		end;
	end;
end;

Procedure Menu();
Var       opcion : char;
begin
  repeat
  ClrScr;
  Writeln('Digite la opcion deseada');
  Writeln();
  Writeln('1: ABMC');
  Writeln('2: Listado');
  Writeln('3: Estadisticas');
  Writeln('4: Agregar personas al registro');
  Writeln();
  Writeln('ESC: Salir');
  repeat
  opcion := Readkey;
  until (opcion = '1') or (opcion = '2') or (opcion = '3') or (opcion = '4') or (opcion = #27);
    case opcion of
      '1': begin
           ComprobarApertura(archivo, infectados);
           Abmc();
           Close(archivo);
      end;
      '2': begin
			ClrScr;
			ListadoOrdenado(archivo, registro);
			end;
      '3': begin
			ClrScr;
			ComprobarApertura(archivo, infectados);
			EstadisticasMenu(archivo, registro);
			Close(archivo);
			end;
      '4': begin
			Agregar(archivo, archProvincia, registro, regProvincia);
           end;
      #27: begin
      Writeln();
      Writeln('Gracias por usar nuestro servicio');
			end;
	  end;
   until (opcion = #27);
end;



END.

