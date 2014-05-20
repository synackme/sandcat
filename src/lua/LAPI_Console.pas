unit LAPI_Console;

{
  Sandcat Console library
  Copyright (c) 2011-2014, Syhunt Informatica
  License: 3-clause BSD license
  See https://github.com/felipedaragon/sandcat/ for details.
}

interface

uses Lua;

function lua_addconsolecommand(L: plua_State): integer; cdecl;
function lua_console_clear(L: plua_State): integer; cdecl;
function lua_console_sethandler(L: plua_State): integer; cdecl;
function lua_console_gethandler(L: plua_State): integer; cdecl;
function lua_console_setfontcolor(L: plua_State): integer; cdecl;
function lua_console_setcolor(L: plua_State): integer; cdecl;
function lua_console_setmanual(L: plua_State): integer; cdecl;
function lua_console_output(L: plua_State): integer; cdecl;
function lua_newconsoletab(L: plua_State): integer; cdecl;
function lua_console_writeln(L: plua_State): integer; cdecl;
function lua_console_write(L: plua_State): integer; cdecl;
function lua_console_restore(L: plua_State): integer; cdecl;
function lua_console_setcurrentline(L: plua_State): integer; cdecl;

implementation

uses uMain, pLua, CatHTTP, CatLuaUtils, uZones, CatConsole;

function lua_addconsolecommand(L: plua_State): integer; cdecl;
begin
  addconsolecommand(lua_tostring(L, 1), lua_tostring(L, 2), lua_tostring(L, 3));
  result := 1;
end;

function lua_console_restore(L: plua_State): integer; cdecl;
begin
  if sandconsole <> nil then
  begin
    sandconsole.ResetFull;
    sandconsole.LoadSettings(settings.Preferences);
  end;
  result := 1;
end;

function lua_console_setcolor(L: plua_State): integer; cdecl;
begin
  if sandconsole <> nil then
    sandconsole.console.Color := HtmlColorToColor(plua_tostring(L, 1));
  result := 1;
end;

function lua_console_setfontcolor(L: plua_State): integer; cdecl;
begin
  if sandconsole <> nil then
    sandconsole.console.Font.Color := HtmlColorToColor(plua_tostring(L, 1));
  result := 1;
end;

function lua_console_setcurrentline(L: plua_State): integer; cdecl;
begin
  if sandconsole <> nil then
    sandconsole.SetCurrentLine(plua_tostring(L, 1));
  result := 1;
end;

function lua_console_writeln(L: plua_State): integer; cdecl;
begin
  tabmanager.ActiveTab.LogWriteLn(pLuaAnyToString(L, 1));
  result := 1;
end;

function lua_console_write(L: plua_State): integer; cdecl;
begin
  tabmanager.ActiveTab.logwrite(pLuaAnyToString(L, 1));
  result := 1;
end;

function lua_console_output(L: plua_State): integer; cdecl;
begin
  contentarea.Console_Output(lua_toboolean(L, 2));
  result := 1;
end;

function lua_console_sethandler(L: plua_State): integer; cdecl;
begin
  if sandconsole <> nil then
  begin
    sandconsole.customhandler := plua_tostring(L, 1);
    sandconsole.setprompt(plua_tostring(L, 1));
  end;
  result := 1;
end;

function lua_console_gethandler(L: plua_State): integer; cdecl;
var
  s: string;
begin
  if sandconsole <> nil then
    s := sandconsole.customhandler;
  plua_pushstring(L, s);
  result := 1;
end;

function lua_console_setmanual(L: plua_State): integer; cdecl;
begin
  contentarea.UseManualConsole := lua_toboolean(L, 2);
  result := 1;
end;

function lua_console_clear(L: plua_State): integer; cdecl;
begin
  if sandconsole <> nil then
    sandconsole.clear;
  result := 1;
end;

function lua_newconsoletab(L: plua_State): integer; cdecl;
begin
  tabmanager.NewTab_Console;
  result := 1;
end;

end.