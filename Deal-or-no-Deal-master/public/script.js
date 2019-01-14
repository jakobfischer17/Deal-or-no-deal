function validateForm() {
	// Check username
	var x = document.forms["myForm"]["username"].value;
	var y = document.forms["myForm"]["password"].value;
	if (x==null || x==""){
		alert("Name must be filled out!");
		return false;
	} else if (x.length < 5) {
		alert("Name must be at least 5 characters long!");
		return false;
	}

	//Check password
	if (y==null || y==""){
		alert("Password must be filled out!");
		return false;
	} else if (y.length < 5) {
		alert("Password must be at least 5 characters long!");
		return false;
	}

	return true;

	}



function validateForm1() {
	// Check username
	var x = document.forms["myForm1"]["message"].value;
	if (x==null || x=="" || x <1 || x>22){
		alert("Please enter the a nubmer between 1 and 22!");
		return false;
	} 

	return true;

	}

function validateForm2() {
	// Check username
	var x = document.forms["myForm2"]["message"].value;
	if (x==null || x=="" || $webgame.figures.include(x) == false ){
		alert("Please enter the a nubmer between 1 and 22!");
		return false;
	} 

	return true;

	}



	//if (x <1 || x>22)
	// {
	//	alert("The number should be between 1 and 22");
	//	return false;
	//}

	//return true;

	

	//if (openedboxes[x - 1] == 1){
	//	alert("You cannot open a box you have already opened!")
	//	return false;
	//}

	//return true;

	//}	