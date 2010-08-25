<?php

$con = mysql_connect("localhost","root","");

if (!$con)
{
	die('Could not connect: ' . mysql_error());
}

mysql_select_db('clearsenses_v3',$con);



$sqlmt = "SELECT t2.product_id, t2.dimension, t2.material, t2.specialbuyer, t2.isbn, t2.author, t2.publisher, t2.cover_type, t2.edition, t2.description, t2.keyword  from jos_vm_product t2 ";

$rsmd = mysql_query($sqlmt) or die(mysql_error());

while($rowmd = mysql_fetch_array($rsmd))
{
//print_r($rowmd);
$sqlnp = "INSERT INTO jos_vm_product_type_3 (product_id, dimension, material, specialbuyer, isbn, author, publisher, cover_type, edition, description, metadata) VALUES ('".trim($rowmd['product_id'])."', '".trim($rowmd['dimension'])."', '".trim($rowmd['material'])."', '".trim($rowmd['specialbuyer'])."', '".trim($rowmd['isbn'])."', '".trim($rowmd['author'])."', '".trim($rowmd['publisher'])."', '".trim($rowmd['cover_type'])."', '".trim($rowmd['edition'])."', '".trim($rowmd['description'])."','".trim($rowmd['keyword'])."')";
mysql_query($sqlnp);

$sqlnp1 = "INSERT INTO jos_vm_product_product_type_xref (product_id, product_type_id) VALUES ('".trim($rowmd['product_id'])."',3)";
mysql_query($sqlnp1);



}
?>
