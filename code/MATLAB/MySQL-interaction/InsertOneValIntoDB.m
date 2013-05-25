function InsertOneValIntoDB(conn,tableName,id,description,ImgFile)

if isconnection(conn)
     qry = sprintf('INSERT INTO %s(PhotoID,Description,ImgFile) VALUES(%s,%s,''''ImgFile'''');',tableName,id,description);
    display(qry);
    fetch(exec(conn, qry));
else
    display('MySql Connection Error');
end

