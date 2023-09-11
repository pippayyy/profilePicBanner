<!DOCTYPE html>
<head>

  <meta charset="utf-8" />
  <title>Profile Picture Overlay</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

	<style>
		#overlay-img, .overlay-img {
			width:500px;
			height:auto;
			display:block;
			margin: 30px auto;
		}

		input {
			display: block;
			margin: 10px auto;
		}

		.inputfile {
			width: 0.1px;
			height: 0.1px;
			opacity: 0;
			overflow: hidden;
			position: absolute;
			z-index: -1;
		}

		.inputfile + label {
			border-radius: 2px;
			margin-top:40px;
			display: inline-block;
			padding: 10px 30px;
		    font-weight: 700;
		    text-transform: uppercase;
		  	vertical-align: middle;
		    color: white;
		    background-color: blue;
		    -webkit-tap-highlight-color: transparent;
		}

		.inputfile:focus + label,
		.inputfile + label:hover {
		    box-shadow: 0 5px 11px 0 rgba(0, 0, 0, 0.18), 0 4px 15px 0 rgba(0, 0, 0, 0.15);
		}

		.inputfile + label {
			cursor: pointer; /* "hand" cursor */
		}

		.inputfile:focus + label {
			outline: 1px dotted #000;
			outline: -webkit-focus-ring-color auto 5px;
		}

		.overlay-div {
			text-align:center;
		}

		.madeBy {
			text-align:center;
			font-size: .7em;
			margin: 50px auto 10px auto;
		}

	</style>


</head>
<body>


  <script type="text/javascript" src="caman.full.js"></script>
  <script type="text/javascript" src="bannersJson.js"></script>

<div class="container">
	<div class="row mt-5">
		<div class="col-5">

			<h2>Profile picture banner tool</h2>
			<p>Overlay the brand new VBTS banner on your profile picture in just a few easy steps!</p>
			<ol>
				<li><b>Select</b> your profile picture</li>
				<li><b>Save </b> your new picture by right-clicking and selecting 'save as'</li>
				<li><b>Replace</b> your profile picture on all your work channels e.g Teams</li>
			</ol>

			<!-- <p><em>Note: square images work best!</em></p> -->
			<!-- <a href='overlayNew.png' download>download me</a> -->

			<div>
				<input type="file" accept="image/*" onchange="loadFile(event)" id="file" class="inputfile" />
				<label for="file">Select Profile Picture</label>
			</div>

			<canvas style="display:none;" id="canvasImg"></canvas>

		</div>

		<div class="col-5">

			<div class="overlay-div mx-3">
				<img id="overlay-img" class="w-75" src="redBannerLogoVersionPLAIN.png" />
			</div>

		</div>

		<div class="col-2 text-center px-4">
			<h6 >Select banner:</h6>
			<div id="bannerSpace">
				Javascript inserts banners here
			</div>
		</div>

	</div>
</div>


	<script>
		var bannerDiv = document.getElementById("bannerSpace");
		var bannerHtml = "";

		bannersJson.forEach(function (bannerItem) {
			bannerHtml += `<button class="p-0">
								<div class="card">
									<img src="${bannerItem.imgPlain}" data-overlay="${bannerItem.imgOverlay}" class="card-img-top px-2 bannerPic" alt="...">
								</div>
							</button>`;
		});

		bannerDiv.innerHTML = bannerHtml;

  	</script>


	<script>
		
		//Add event listener for banner images
		const bannerImgs = document.querySelectorAll('.bannerPic');

		bannerImgs.forEach(el => el.addEventListener('click', event => {
			applyBanner(event.target.getAttribute("data-overlay"));
		}));

		var applyBanner = function(picUrl) {

			//get img data from canvas
			// var canvas = document.getElementById("canvasImg");
			// const context = canvas.getContext('2d');
			// context.clearRect(0, 0, canvas.width, canvas.height);
			// ctx.drawImage(inputImage, outputX, outputY);
			var resizedImageData = document.getElementById("canvasImg").toDataURL();

			createOverlay(resizedImageData, picUrl);

		}
	</script>

	<script>
	  var loadFile = function(event) {
	    var reader = new FileReader();
	    reader.onload = function() {

			// the desired aspect ratio of our output image (width / height)
			const outputImageAspectRatio = 1;

			// this image will hold our source image data
			const inputImage = new Image();
			inputImage.src = reader.result

			// we want to wait for our image to load
			inputImage.onload = () => {
				//store the width and height of our image
				const inputWidth = inputImage.naturalWidth;
				const inputHeight = inputImage.naturalHeight;

				// get the aspect ratio of the input image
				const inputImageAspectRatio = inputWidth / inputHeight;

				// if it's bigger than our target aspect ratio
				let outputWidth = inputWidth;
				let outputHeight = inputHeight;
				if (inputImageAspectRatio > outputImageAspectRatio) {
					outputWidth = inputHeight * outputImageAspectRatio;
				} else if (inputImageAspectRatio < outputImageAspectRatio) {
					outputHeight = inputWidth / outputImageAspectRatio;
				}

				// calculate the position to draw the image at
				const outputX = (outputWidth - inputWidth) * 0.5;
				const outputY = (outputHeight - inputHeight) * 0.5;

				// create a canvas that will present the output image
				const outputImage = document.getElementById('canvasImg');

				// set it to the same size as the image
				outputImage.width = outputWidth;
				outputImage.height = outputHeight;

				// draw our image at position 0, 0 on the canvas
				const ctx = outputImage.getContext('2d');
				ctx.drawImage(inputImage, outputX, outputY);

				// show both the image and the canvas
				// document.body.appendChild(inputImage);
				// document.body.appendChild(outputImage);

				var resizedImageData = document.getElementById("canvasImg").toDataURL();

				createOverlay(resizedImageData, 'redBannerLogoVersion.png');
			};

	    };
	    reader.readAsDataURL(event.target.files[0]);
	  };



	var createOverlay = function(uploadImage, bannerUrl) {
	  	var baseImg = uploadImage;
	  	Caman("#overlay-img", function () {
			this.brightness(5);
			this.render();
			this.newLayer(function() {
			    this.setBlendingMode("normal");
			    this.opacity(100);
			    this.overlayImage(baseImg);

		  	});

		  	this.newLayer(function() {
			    this.setBlendingMode("normal");
			    this.opacity(100);
			    this.overlayImage(bannerUrl);
		  	});

		  	$('#overlay-img').removeAttr('style');
		});

		$('#overlay-img').removeAttr('style');
	};
	</script>
       
        

<script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>

</body>
</html>