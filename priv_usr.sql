-- How to show all privileges from a user in oracle?
-- https://stackoverflow.com/questions/9811670/how-to-show-all-privileges-from-a-user-in-oracle

WITH data 
     AS (SELECT granted_role 
         FROM   dba_role_privs 
         CONNECT BY PRIOR granted_role = grantee 
         START WITH grantee = '&USER') 
SELECT 'SYSTEM'     typ, 
       grantee      grantee, 
       privilege    priv, 
       admin_option ad, 
       '--'         tabnm, 
       '--'         colnm, 
       '--'         owner 
FROM   dba_sys_privs 
WHERE  grantee = '&USER' 
        OR grantee IN (SELECT granted_role 
                       FROM   data) 
UNION 
SELECT 'TABLE'    typ, 
       grantee    grantee, 
       privilege  priv, 
       grantable  ad, 
       table_name tabnm, 
       '--'       colnm, 
       owner      owner 
FROM   dba_tab_privs 
WHERE  grantee = '&USER' 
        OR grantee IN (SELECT granted_role 
                       FROM   data) 
ORDER  BY 1; 
