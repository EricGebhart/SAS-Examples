

ods package;

ods package add file="test.sas";
ods package add file="t2.sas";
ods package add file="t3.sas";
ods package add file="t4.sas";
ods package add file="t5.sas";
ods package add file="t6.sas";
ods package add file="t7.sas";
ods package add file="t8.sas";
ods package add file="t9.sas";
ods package add file="t10.sas";
ods package add file="t11.sas";
ods package add file="t12.sas";
ods package add file="t13.sas";
ods package add file="t14.sas";
ods package add file="eric.retrv.sas";

ods package publish archive properties(archive_name="t14.spk" archive_path="./");

ods package close;
