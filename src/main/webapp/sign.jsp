<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ký số đơn hàng</title>

<style>
body {
	font-family: Arial;
	max-width: 900px;
	margin: auto;
	padding: 30px;
}

textarea {
	width: 100%;
	height: 250px;
}

button {
	padding: 12px 20px;
	background: black;
	color: white;
	border: none;
	cursor: pointer;
}
</style>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jsencrypt/3.3.2/jsencrypt.min.js"></script>

</head>
<body>

	<h2>Ký số đơn hàng</h2>

	<p>Dán Private Key của bạn vào đây:</p>

	<textarea id="privateKey"></textarea>

	<br>
	<br>

	<button onclick="signOrder()">Ký đơn hàng</button>

	<form id="signForm" action="SignServlet" method="post">

		<input type="hidden" name="signature" id="signature">

	</form>

	<script>

function signOrder(){

    let privateKey =
        document.getElementById("privateKey").value;

    if(privateKey.trim()==""){
        alert("Vui lòng nhập Private Key");
        return;
    }

    let orderCode =
        "${sessionScope.lastOrderCode}";

    try{

        let signer = new JSEncrypt();

        signer.setPrivateKey(privateKey);

        let signature =
            signer.sign(
                orderCode,
                CryptoJS.SHA256,
                "sha256"
            );

        document.getElementById("signature").value =
            signature;

        document.getElementById("signForm").submit();

    }catch(e){

        alert("Private Key không hợp lệ");

    }
}
</script>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>

</body>
</html>