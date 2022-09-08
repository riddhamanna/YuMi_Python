import cv2
import numpy as np
from operator import itemgetter
from glob import glob
from matplotlib import pyplot as plt
import time

ARUCO_DICT = {
	"DICT_4X4_50": cv2.aruco.DICT_4X4_50,
	"DICT_4X4_100": cv2.aruco.DICT_4X4_100,
	"DICT_4X4_250": cv2.aruco.DICT_4X4_250,
	"DICT_4X4_1000": cv2.aruco.DICT_4X4_1000,
	"DICT_5X5_50": cv2.aruco.DICT_5X5_50,
	"DICT_5X5_100": cv2.aruco.DICT_5X5_100,
	"DICT_5X5_250": cv2.aruco.DICT_5X5_250,
	"DICT_5X5_1000": cv2.aruco.DICT_5X5_1000,
	"DICT_6X6_50": cv2.aruco.DICT_6X6_50,
	"DICT_6X6_100": cv2.aruco.DICT_6X6_100,
	"DICT_6X6_250": cv2.aruco.DICT_6X6_250,
	"DICT_6X6_1000": cv2.aruco.DICT_6X6_1000,
	"DICT_7X7_50": cv2.aruco.DICT_7X7_50,
	"DICT_7X7_100": cv2.aruco.DICT_7X7_100,
	"DICT_7X7_250": cv2.aruco.DICT_7X7_250,
	"DICT_7X7_1000": cv2.aruco.DICT_7X7_1000,
	"DICT_ARUCO_ORIGINAL": cv2.aruco.DICT_ARUCO_ORIGINAL,
	"DICT_APRILTAG_16h5": cv2.aruco.DICT_APRILTAG_16h5,
	"DICT_APRILTAG_25h9": cv2.aruco.DICT_APRILTAG_25h9,
	"DICT_APRILTAG_36h10": cv2.aruco.DICT_APRILTAG_36h10,
	"DICT_APRILTAG_36h11": cv2.aruco.DICT_APRILTAG_36h11
}

# arucoDictStr = input("Enter aruco dict: ")
#
# topleftID = int(input("Enter topleft aruco ID: "))
# toprightID = int(input("Enter topright aruco ID: "))
# bottomleftID = int(input("Enter bottomleft aruco ID: "))
# bottomrightID = int(input("Enter bottomright aruco ID: "))
#
# width = int(input("Enter width in mm: "))
# height = int(input("Enter height in mm:"))
# factor = int(input("Enter factor (final w/h in pixel = factor*w/h in mm): "))

arucoDictStr = "DICT_6X6_100"

topleftID = 1
toprightID = 2
bottomleftID = 3
bottomrightID = 4

width = 300
height = 200
factor = 2

cap = cv2.VideoCapture(2)
cap.set(cv2.CAP_PROP_FRAME_WIDTH,4096)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT,3000)

ptsSrc = [[0,0],[width*factor,0],[0,height*factor],[width*factor,height*factor]]
ptsDes = np.float32([[0,0],[width*factor,0],[0,height*factor],[width*factor,height*factor]])

cv2.namedWindow('image')

while True:
	ret, image = cap.read()
	# cv2.imwrite("grid.png",img)
	arucoDict = cv2.aruco.Dictionary_get(ARUCO_DICT[arucoDictStr])
	arucoParams = cv2.aruco.DetectorParameters_create()
	(corners, ids, rejected) = cv2.aruco.detectMarkers(image, arucoDict, parameters=arucoParams)

	target_corners_found = 0

	# verify *at least* one ArUco marker was detected
	if len(corners) > 0:
		# flatten the ArUco IDs list
		ids = ids.flatten()
		# loop over the detected ArUCo corners
		target_corners_found = 0
		for (markerCorner, markerID) in zip(corners, ids):
			# extract the marker corners (which are always returned in
			# top-left, top-right, bottom-right, and bottom-left order)
			corners = markerCorner.reshape((4, 2))
			(topLeft, topRight, bottomRight, bottomLeft) = corners
			# convert each of the (x, y)-coordinate pairs to integers
			topRight = [int(topRight[0]), int(topRight[1])]
			bottomRight = [int(bottomRight[0]), int(bottomRight[1])]
			bottomLeft = [int(bottomLeft[0]), int(bottomLeft[1])]
			topLeft = [int(topLeft[0]), int(topLeft[1])]
			# draw the bounding box of the ArUCo detection
			cv2.line(image, topLeft, topRight, (0, 255, 0), 2)
			cv2.line(image, topRight, bottomRight, (0, 0, 255), 2)
			cv2.line(image, bottomRight, bottomLeft, (0, 255, 0), 2)
			cv2.line(image, bottomLeft, topLeft, (0, 0, 255), 2)
			# compute and draw the center (x, y)-coordinates of the ArUco
			# marker
			cX = int((topLeft[0] + bottomRight[0]) / 2.0)
			cY = int((topLeft[1] + bottomRight[1]) / 2.0)
			cv2.circle(image, (cX, cY), 4, (0, 0, 255), -1)
			# draw the ArUco marker ID on the image
			cv2.putText(image, str(markerID),(topLeft[0], topLeft[1] - 15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
			if markerID == topleftID:
				ptsSrc[0]=topLeft
				target_corners_found += 1
			if markerID == toprightID:
				ptsSrc[1]=topRight
				target_corners_found += 1
			if markerID == bottomleftID:
				ptsSrc[2]=bottomLeft
				target_corners_found += 1
			if markerID == bottomrightID:
				ptsSrc[3]=bottomRight
				target_corners_found += 1
	h,w,layers = image.shape
	h = int(h/factor)
	w = int(w/factor)
	image = cv2.resize(image,(w,h))
	cv2.imshow("image",image)
	if target_corners_found == 4:
		ptsSrc = np.float32(ptsSrc)
		TrMat = cv2.getPerspectiveTransform(ptsSrc,ptsDes)
		transformed = cv2.warpPerspective(image,TrMat,(width*factor,height*factor))
		cv2.imshow("transformed",transformed)
	# else :
	# 	cv2.destroyWindow("transformed")

	if cv2.waitKey(1) & 0xFF == 27:#ord('q'):
		break
cap.release()
cv2.destroyAllWindows()
