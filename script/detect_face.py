import dlib
import cv2
import sys

def detect_face(image_path):
  detector = dlib.get_frontal_face_detector()

  image = cv2.imread(image_path)
  gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
  faces = detector(gray)
  if faces:
    face = faces[0]  # Assuming one face
    x, y, w, h = face.left(), face.top(), face.width(), face.height()
    return f"{x} {y} {w} {h}"
  else:
    return None

print(detect_face(sys.argv[1]))
