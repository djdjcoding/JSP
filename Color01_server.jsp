<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="javax.imageio.*" %>
<%@ page import="java.awt.image.*" %>
<%@ page import="java.lang.Math" %>

    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Color Image Processing - Server (RC 1)</title>
</head>
<body>
<%!
///////////////////////
// 전역 변수부
///////////////////////
int[][][] inImage;
int inH, inW;
int[][][] outImage;
int outH, outW;
File inFp, outFp;

// Parameter Variable
String algo, para1, para2;
String inFname, outFname;

///////////////////////
// 영상처리 함수부
///////////////////////
public void reverseImage() { // 반전 영상
	// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
	outH = inH;
	outW = inW;
	outImage= new int[3][outH][outW];
	/// ** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++) {
		for (int i=0; i< inH; i++) {
			for (int k=0; k<inW; k++) {
				outImage[rgb][i][k] = 255 - inImage[rgb][i][k];
			}
		}
	}
}

public void addImage() {// Add Image 영상
	// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
	outH = inH;
	outW = inW;
	outImage= new int[3][outH][outW];
	/// ** Image Processing Algorithm **
	int value = Integer.parseInt(para1);
	for (int rgb=0; rgb<3; rgb++){
		for (int i=0; i< inH; i++) {
			for (int k=0; k<inW; k++) {
				if ( inImage[rgb][i][k] + value > 255)
					outImage[rgb][i][k] = 255;
				else if ( inImage[rgb][i][k] + value < 0)
					outImage[rgb][i][k] = 0;
				else 
					outImage[rgb][i][k] = inImage[rgb][i][k] + value ;
			}
		}
	}
}

public void mulImage() { //곱하기(밝게하기)
	// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
	outH = inH;
	outW = inW;
	outImage= new int[3][outH][outW];
	/// ** Image Processing Algorithm **
	int value = Integer.parseInt(para1);
	for (int rgb=0; rgb<3; rgb++){
		for (int i=0; i< inH; i++) {
			for (int k=0; k<inW; k++) {
				if(inImage[rgb][i][k]*value>255)
					outImage[rgb][i][k] = 255;
				else if(inImage[rgb][i][k]*value<0)
					outImage[rgb][i][k] = 0;
				else 
					outImage[rgb][i][k] = inImage[rgb][i][k] * value ;
			}
		} 
	}
}

public void divImage() {// 나누기(어둡게하기)
	// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
	outH = inH;
	outW = inW;
	outImage= new int[3][outH][outW];
	/// ** Image Processing Algorithm **
	int value = Integer.parseInt(para1);
	for (int rgb=0; rgb<3; rgb++){
		for (int i=0; i< inH; i++) {
			for (int k=0; k<inW; k++) {
				if(inImage[rgb][i][k]/value>255)
					outImage[rgb][i][k] = 255;			
				else if(inImage[rgb][i][k]/value<0)
					outImage[rgb][i][k] = 0;
				else 
					outImage[rgb][i][k] = inImage[rgb][i][k] / value ;
			}
		}
	}
}

public void bwImage(){ //흑백처리
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	int sum = 0;
	float avg = 0;
	
	for (int rgb=0; rgb<3; rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				sum = sum + inImage[rgb][i][k];
			}
		}
	}

	avg = sum/(3*inH*inW);
	
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				int sumValue = inImage[0][i][k] + inImage[1][i][k] + inImage[2][i][k];
				int avgValue = sumValue / 3;
				if(avgValue>=avg){
					outImage[0][i][k] = 255;
					outImage[1][i][k] = 255;
					outImage[2][i][k] = 255;
				}
				else{
					outImage[0][i][k] = 0;
					outImage[1][i][k] = 0;
					outImage[2][i][k] = 0;
				}
			}
		}
	}


public void paracap(){ //파라볼라 캡
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	//** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				outImage[rgb][i][k] = (int)(255*Math.pow((inImage[rgb][i][k]/127.0-1),2));
			}
		}
	}
}

public void paracup(){ //파라볼라 컵
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	//** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				outImage[rgb][i][k] = (int)(255-(255*Math.pow((inImage[rgb][i][k]/127.0-1),2)));
			}
		}
	}
}

public void gammaImage(){ // 감마
	//감마
	outH =inH;
	outW =inW;
	// 메모리 할당
	outImage = new int[3][outH][outW];
	/// ** Image Processing Algorithm **
		double value = Integer.parseInt(para1);
	if(value <0)
		value =1/(1-value);
	else
		value +=1;

	//감마 변환
	for (int rgb=0; rgb<3; rgb++){
		for(int i=0; i<inH; i++){
			for(int k=0; k<inW; k++){
				double result=(Math.pow((double)(inImage[rgb][i][k]/255.0),(double)(value))*255+0.5);
				if(result <0)
					result=0;
				else if(result >255)
					result=255;
				outImage[rgb][i][k] = (int)result;
			}
		}
	}
}

public void grayImage(){ // 회색처리
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	int sum = 0;
	float avg = 0;
	
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			int sumValue = inImage[0][i][k] + inImage[1][i][k] + inImage[2][i][k];
			int avgValue = sumValue / 3;
				
			outImage[0][i][k] = avgValue;
			outImage[1][i][k] = avgValue;
			outImage[2][i][k] = avgValue;
		}
	}
}

public void lrImage(){ // 좌우반전
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				outImage[rgb][i][k] = inImage[rgb][outH-i-1][k];
			}
		}
	}
}

public void udImage(){ // 상하반전
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	//** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				outImage[rgb][i][k] = inImage[rgb][i][outW-k-1];
			}
		}
	}
}

public void zoomIn() { // 확대
	// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
	int scale = Integer.parseInt(para1);
	outH = inH*scale;
	outW = inW*scale;
	outImage= new int[3][outH][outW];
	/// ** Image Processing Algorithm **
	
	for (int rgb=0;rgb<3;rgb++){
		for (int i=0; i< outH; i++) {
			for (int k=0; k<outW; k++) {
				outImage[rgb][i][k] = inImage[rgb][i/scale][k/scale];
			}
		}
	}
}

public void zoomOut() { // 축소
	// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
	int scale = Integer.parseInt(para1);
	outH = inH/scale;
	outW = inW/scale;
	outImage= new int[3][outH][outW];
	/// ** Image Processing Algorithm **
	
	for (int rgb=0;rgb<3;rgb++){
		for (int i=0; i< inH; i++) {
			for (int k=0; k<inW; k++) {
				outImage[rgb][(int)(i/scale)][(int)(k/scale)] = inImage[rgb][i][k];
			}
		}
	}
}

public void rotate(){ // 회전
	int CenterH, CenterW, newH, newW , Val;
	double Radian, PI;
	// PI = 3.14159265358979;
	PI = Math.PI;
	int degree = Integer.parseInt(para1);
	
	Radian = -degree * PI / 180.0; 
	outH = (int)(Math.floor((inW) * Math.abs(Math.sin(Radian)) + 
			(inH) * Math.abs(Math.cos(Radian))));
	outW = (int)(Math.floor((inW) * Math.abs(Math.cos(Radian)) + 
			(inH) * Math.abs(Math.sin(Radian))));
	CenterH = outH / 2;
	CenterW = outW / 2;
	outImage = new int[3][outH][outW];
	
	for (int rgb = 0; rgb < 3; rgb++) {
		for (int i = 0; i < outH; i++) {
			for (int k = 0; k < outW; k++) {
				newH = (int)((i - CenterH) * Math.cos(Radian) - (k - CenterW) 
						* Math.sin(Radian) + inH / 2);
				newW = (int)((i - CenterH) * Math.sin(Radian) + (k - CenterW) 
						* Math.cos(Radian) + inW / 2);
				if (newH < 0 || newH >= inH) {
					//Val = 255;
					outImage[0][i][k] = 55;
					outImage[1][i][k] = 59;
					outImage[2][i][k] = 68;
							
				} else if (newW < 0 || newW >= inW) {
					//Val = 255;
					outImage[0][i][k] = 55;
					outImage[1][i][k] = 59;
					outImage[2][i][k] = 68;
				} else {
					Val = inImage[rgb][newH][newW];
					outImage[rgb][i][k] = Val;
				}
				
			}
		}
	}
}

public void emboss(){ // 엠보싱
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double[][] mask = {{-1.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,1.0}};

	double[][][] tmpInImage = new double[3][outH+2][outW+2];
	int[][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k] = 127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						S = S + tmpInImage[rgb][i+m][k+n] * mask[m][n];
					}
				}
				tmpOutImage[rgb][i][k] = (int)S;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				tmpOutImage[rgb][i][k] = tmpOutImage[rgb][i][k]+127;
			}
		}
	}
	// ** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k] = 255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k] = 0;
				else
					outImage[rgb][i][k] = (int)tmpOutImage[rgb][i][k];
				
			}
		}
	}
}

public void blurr(){ // 블러링
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double[][] mask = {{1.0/9,1.0/9,1.0/9},{1.0/9,1.0/9,1.0/9},{1.0/9,1.0/9,1.0/9}};

	double[][][] tmpInImage = new double[3][outH+2][outW+2];
	int[][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k] = 127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						S = S + tmpInImage[rgb][i+m][k+n] * mask[m][n];
					}
				}
				tmpOutImage[rgb][i][k] = (int)S;
			}
		}
	}

	// ** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k] = 255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k] = 0;
				else
					outImage[rgb][i][k] = (int)tmpOutImage[rgb][i][k];
				
			}
		}
	}
}

public void sharp(){ // 샤프닝
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double[][] mask = {{0.0,-1.0,0.0},{-1.0,5.0,-1.0},{0.0,-1.0,0.0}};

	double[][][] tmpInImage = new double[3][outH+2][outW+2];
	int[][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k] = 127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						S = S + tmpInImage[rgb][i+m][k+n] * mask[m][n];
					}
				}
				tmpOutImage[rgb][i][k] = (int)S;
			}
		}
	}

	// ** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k] = 255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k] = 0;
				else
					outImage[rgb][i][k] = (int)tmpOutImage[rgb][i][k];
				
			}
		}
	}
}

public void highsharp(){ // 고주파 샤프닝
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double[][] mask = {{-1.0/9,-1.0/9,-1.0/9},{-1.0/9,8.0/9,-1.0/9},{-1.0/9,-1.0/9,-1.0/9}};

	double[][][] tmpInImage = new double[3][outH+2][outW+2];
	int[][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k] = 127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						S = S + tmpInImage[rgb][i+m][k+n] * mask[m][n];
					}
				}
				tmpOutImage[rgb][i][k] = (int)S;
			}
		}
	}

	// ** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k] = 255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k] = 0;
				else
					outImage[rgb][i][k] = (int)tmpOutImage[rgb][i][k];
				
			}
		}
	}
}

public void laplacian(){ // 라플라시안
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];

	double[][] mask = {{0.0,1.0,0.0},{1.0,-4.0,1.0},{0.0,1.0,0.0}};

	double[][][] tmpInImage = new double[3][outH+2][outW+2];
	int[][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
				tmpInImage[rgb][i][k] = 127.0;
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
			}
		}
	}

	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double S = 0.0;
				for(int m=0;m<3;m++){
					for(int n=0;n<3;n++){
						S = S + tmpInImage[rgb][i+m][k+n] * mask[m][n];
					}
				}
				tmpOutImage[rgb][i][k] = (int)S;
			}
		}
	}

	// ** Image Processing Algorithm **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
				if(tmpOutImage[rgb][i][k]>255.0)
					outImage[rgb][i][k] = 255;
				else if(tmpOutImage[rgb][i][k]<0.0)
					outImage[rgb][i][k] = 0;
				else
					outImage[rgb][i][k] = (int)tmpOutImage[rgb][i][k];
				
			}
		}
	}
}

public void lsImage(){ // 명도 조절
	outH = inH;
	outW = inW;
	
	outImage = new int[3][outH][outW];
	int value = Integer.parseInt(para1);
	if(value>0){
		value = (value+10)/10;
		for(int rgb=0;rgb<3;rgb++){
			for(int i=0;i<inH;i++){
				for(int k=0;k<inW;k++){
					int pixel = inImage[rgb][i][k];
					if(pixel > 127){
						if(pixel * value >255)
							pixel = 255;
						pixel *= value;
					}
					else
						pixel /= value;
					outImage[rgb][i][k] = pixel;
				}
			}
		}
	}
	else{
		value = -(value-10)/10;
		for(int rgb=0;rgb<3;rgb++){
			for(int i=0;i<inH;i++){
				for(int k=0;k<inW;k++){
					int pixel = inImage[rgb][i][k];
					if(pixel>127){
						if(pixel/value<127)
							pixel = 127;
						pixel /= value;
					}
					else{
						if(pixel*value>127)
							pixel /= value;
					}
					outImage[rgb][i][k] = pixel;
				}
			}
		}
	}
}

public void boundary(){ //경계선 검출
	outH = inH;
	outW = inW;
	double[][] maskW = {{-1.0,-1.0,-1.0},{0.0,0.0,0.0},{1.0,1.0,1.0}};
	double[][] maskH = {{-1.0,0.0,1.0},{-1.0,0.0,1.0},{-1.0,0.0,1.0}};
	
	int [][][] tmpImageW = new int[3][inH+2][inW+2];
	int [][][] tmpImageH = new int[3][inH+2][inW+2];
	int [][][] tmpImageW2 = new int[3][inH][inW];
	int [][][] tmpImageH2 = new int[3][inH][inW];
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				tmpImageW[rgb][i+1][k+1] = inImage[rgb][i][k];
				tmpImageH[rgb][i+1][k+1] = inImage[rgb][i][k];
			}
		}
	}
	
	outImage = new int[3][outH][outW];
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				double x = 0.0, y= 0.0;
				for(int m=0; m<3; m++){
					for(int n=0;n<3;n++){
						x += maskW[m][n]*tmpImageW[rgb][i+m][k+n];
						y += maskH[m][n]*tmpImageW[rgb][i+m][k+n];
					}
				}
				int v = (int)Math.sqrt(x*x+y*y);
				if(v>255)
					v=255;
				else if(v<0)
					v=0;
				outImage[rgb][i][k] = v;
			}
		}
	}
}

public void move(){ // 이동
	int value = Integer.parseInt(para1);
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				outImage[rgb][i][k] = 0;
			}
		}
	}
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH-value;i++){
			for(int k=0;k<inW-value;k++){
				outImage[rgb][i+value][k+value] = inImage[rgb][i][k];
			}
		}
	}
}

public void endIn(){ //엔드인
	outH = inH;
	outW = inW;
	
	int low;
	int high;
	
	outImage = new int[3][outH][outW];
	
	low = inImage[0][0][0];
	high = inImage[0][0][0];
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				int pixel = inImage[rgb][i][k];
				if(pixel < low)
					low = pixel;
				else if(pixel>high)
					high = pixel;
			}
		}
	}
	low += 50;
	high -= 50;
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				int inValue = inImage[rgb][i][k];
				int outValue = (inValue-low)/(high-low)*255;
				if(outValue>255)
					outValue=255;
				else if(outValue<0)
					outValue=0;
				outImage[rgb][i][k] = outValue;
			}
		}
	}
}

public void equalize(){ // 평활화
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	int histoR[] = new int[256];
	int histoG[] = new int[256];
	int histoB[] = new int[256];
	
	for(int i=0;i<256;i++){
		histoR[i] = 0;
		histoG[i] = 0;
		histoB[i] = 0;
	}
	
	for(int i=0;i<inH;i++){
		for(int k=0;k<inW;k++){
			histoR[inImage[0][i][k]]++;
			histoG[inImage[1][i][k]]++;
			histoB[inImage[2][i][k]]++;
		}
	}

	int sumHistoR[] = new int[256];
	int sumHistoG[] = new int[256];
	int sumHistoB[] = new int[256];
	
	for(int i=0;i<256;i++){
		sumHistoR[i] = 0;
		sumHistoG[i] = 0;
		sumHistoB[i] = 0;
	}
	
	int sumValueR = 0;
	int sumValueG = 0;
	int sumValueB = 0;
	
	for(int i=0;i<256;i++){
		sumValueR += histoR[i];
		sumHistoR[i] = sumValueR;
		
		sumValueG += histoG[i];
		sumHistoG[i] = sumValueG;
		
		sumValueB += histoB[i];
		sumHistoB[i] = sumValueB;
	}
	
	double normalHistoR[] = new double[256];
	double normalHistoG[] = new double[256];
	double normalHistoB[] = new double[256];
	
	for(int i=0;i<256;i++){
		normalHistoR[i] = 0.0;
		normalHistoG[i] = 0.0;
		normalHistoB[i] = 0.0;
	}
	
	for(int i=0;i<256;i++){
		double normalR = sumHistoR[i] * (1.0/(inH*inW)) * 255.0;
		normalHistoR[i] = normalR;
		double normalG = sumHistoG[i] * (1.0/(inH*inW)) * 255.0;
		normalHistoG[i] = normalG;
		double normalB = sumHistoB[i] * (1.0/(inH*inW)) * 255.0;
		normalHistoB[i] = normalB;
	}
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
				outImage[0][i][k] = (int)(normalHistoR[inImage[0][i][k]]);
				outImage[1][i][k] = (int)(normalHistoG[inImage[1][i][k]]);
				outImage[2][i][k] = (int)(normalHistoB[inImage[2][i][k]]);
			}
		}
	}
}

%>
<%
///////////////////////
// 메인 코드부
///////////////////////
// (0) 파라미터 넘겨 받기
MultipartRequest multi = new MultipartRequest(request, "C:/Upload", 
		5*1024*1024, "utf-8", new DefaultFileRenamePolicy());

String tmp;
Enumeration params = multi.getParameterNames(); //주의! 파라미터 순서가 반대
tmp = (String) params.nextElement();
para1 = multi.getParameter(tmp);
tmp = (String) params.nextElement();
algo = multi.getParameter(tmp);
// File
Enumeration files = multi.getFileNames(); // 여러개 파일
tmp = (String) files.nextElement(); // 첫 파일 한개
String filename = multi.getFilesystemName(tmp);// 파일명을 추출


// (1)입력 영상 파일 처리
inFp = new File("c:/Upload/"+filename);
BufferedImage bImage = ImageIO.read(inFp);

// (2) 파일 --> 메모리
// (중요!) 입력 영상의 폭과 높이를 알아내야 함!
inW = bImage.getHeight();
inH = bImage.getWidth();
// 메모리 할당
inImage = new int[3][inH][inW];

// 읽어오기
for(int i=0; i<inH; i++) {
	for (int k=0; k<inW; k++) {
		int rgb = bImage.getRGB(i,k);  // F377D6 
		int r = (rgb >> 16) & 0xFF; // >>2Byte --->0000F3 & 0000FF --> F3
		int g = (rgb >> 8) & 0xFF; // >>1Byte --->00F377 & 0000FF --> 77			
		int b = (rgb >> 0) & 0xFF; // >>0Byte --->F377D6 & 0000FF --> D6
		inImage[0][i][k] = r;
		inImage[1][i][k] = g;
		inImage[2][i][k] = b;
	}
}


// Image Processing
switch (algo) {
	case "101" :
		reverseImage(); break;
	case "102" :
		addImage(); break;
	case "103" :
		mulImage(); break;
	case "104" :
		divImage(); break;
	case "105" :
		bwImage(); break;
	case "106" :
		paracap(); break;
	case "107" :
		paracup(); break;
	case "108" : 
		gammaImage(); break;
	case "109" : 
		grayImage(); break;
	case "110" : 
		lrImage(); break;
	case "111" : 
		udImage(); break;
	case "112" : 
		zoomIn(); break;
	case "113" : 
		zoomOut(); break;
	case "114" : 
		rotate(); break;
	case "115" : 
		move(); break;
	case "116" : 
		emboss(); break;
	case "117" : 
		blurr(); break;
	case "118" : 
		sharp(); break;
	case "119" : 
		highsharp(); break;
	case "120" : 
		laplacian(); break;
	case "121" : 
		lsImage(); break;
	case "122" : 
		boundary(); break;
	case "123" : 
		endIn(); break;
	case "124" : 
		equalize(); break;
}

//(4) 결과를 파일로 저장하기
outFp = new File("c:/out/"+"out_"+filename);
BufferedImage oImage 
	= new BufferedImage(outH, outW, BufferedImage.TYPE_INT_RGB); // Empty Image
//Memory --> File
for (int i=0; i< outH; i++) {
	for (int k=0; k<outW; k++) {
		int r = outImage[0][i][k];  // F3
		int g = outImage[1][i][k];  // 77
		int b = outImage[2][i][k];  // D6
		int px = 0;
		px = px | (r << 16);  // 000000 | (F30000) --> F30000
		px = px | (g << 8);   // F30000 | (007700) --> F37700
		px = px | (b << 0);   // F37700 | (0000D6) --> F377D6
		oImage.setRGB(i,k,px);
	}
}
ImageIO.write(oImage, "jpg", outFp);


out.println("<h1>" + filename + " 영상 처리 완료 !! </h1>");
String url="<p><h2><a href='http://192.168.56.101:8080/";
url += "GrayImageProcessing/download.jsp?file="; 
url += "out_" + filename + "'> !! 다운로드 !! </a></h2>";

out.println(url);


%>
</body>
</html>