
options debug='semantics'; 

ods listing close;


ods package open;

ods package add file="t21.sas";
    
ods package publish archive properties(archive_name="t21.spk" archive_path="./");

    
ods package close clear;
    



