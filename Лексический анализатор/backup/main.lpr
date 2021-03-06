program main;
const
  kwcount=10;
  kwTable:array[1..kwcount] of string[7]=('UNPUT', 'OUTPUT', 'IF', 'THEN',
      'ELSE', 'WHILE', 'DO', 'FUNC', 'RET', 'HALT'); {ключевые слова}
  var
    idCount, consCount, funCount: integer; {число индентификатора, константы,
    текущий символ}
    idTable: array[1..200] of string[15]; {таблица идентификаторов}
    consTable: array[1..200] of integer; {таблица констант}
    funTable: array[1..30] of string[15]; {таблица функций}
    inFile, outFile, consTableFile: Text; {файлы: входной(исходная программа)}
    str, curLex: string[50];
    k, i:integer;

    function kwIndex(lex: string): integer;
    var
      i:integer;
    begin
      kwIndex:=0;
      for i:=0 to kwCount do if lex=kwTable[i] then begin
          kwIndex:=i;
        end;
      end;

      function idIndex(lex: string):integer;
      var
        i:integer;
      begin
        idIndex:=0;
        for i:=0 to idCount do if lex=idtable[i] then begin
            idIndex:=i;
            break
        end;
      end;

      function funIndex(lex: string): integer;
      var
        i: integer;
      begin
        funIndex:=0;
        for i:=0 to funCount do if lex=funTalbe[i] then begin
            funIndex:=i;
            break
        end;
      end;

begin
  writeln('input source filename: ');
  readln(str);

  assign(inFile, str+'.src');
  reset(inFile);
  assign(outFile, str+'.ala');
  rewrite(outFile);

  curState:='S';
  curLex:='';
  idCount:=0;
  consCount:=0;

  while not eof(inFile) do begin
    read(inFile, curTerm);
    if (curTerm <> chr(10)) and (curTerm <> chr(13)) then case curState of {
    перевод строки Chr(13) и возврат каретки Chr(10)}
        'S':begin
          case curTerm of
              'a'..'z', 'A'..'Z':begin
                curState:='A';
                curLex:=curLex + curTerm
              end;
              '0'..'9': begin
                curState:='B';
                curLex:=curLex + curTerm
              end;
              '': begin
                curState:='S';
              end;
              ';','+','-','/','\','(',')','[',']','=','*','{','}': begin
                curState:='S';
                write(outFile, curTerm);
              end;
              ':': begin
                curState:='C';
              end;
              '<', '>': begin
                curState:='D';
                prevTerm:=curTerm;
              end;
              '!': begin
                curState:='E';
              end;
              '|': begin
                prevComState:=curState;
                curState:='F';
              end;
              else begin
                writeln('error');
                halt
              end;
          end;
          end;
          'A': begin
            case cutTerm of
                'a'..'Z', 'A'..'Z', '0'..'9':begin
                    curState:='A';
                    curLex:=curLex + curTerm;
                end;
                '': begin
                   curState:='I';
                end;
                ';','+','-','/','\','(',')','[',']','=','*','{','}': begin
                  curState:='S';
                  if k <> 0 then write(outFile, 'K', k) else begin
                      k:=idIndex(curLex);
                      if k = 0 then begin
                          inc(idCount);
                          idTable[idCount]:=curLex;
                          write(outFile, 'I', idCount)
                          end else write(outFile, 'I', k)
                      end;
                      write(outFile, curTerm);
                      curLex:='';
                  end;
                '(': begin
                  curState:='S';
                  k:=funIndex(curLex);
                  if k <> 0 then write(outFile, 'F', k) else begin
                      inc(funCount);
                      funTable[funCount]:=curLex;
                      write(outFile, 'F', funCount);
                      end;
                  end;
                ':': begin
                    curState:='C';
                    k:=kwIndex(curLex);
                    if k <> 0 then write(outFile, 'K', k) else begin
                    end
                end;
          end;
        end;
    end;
  end;
end.

