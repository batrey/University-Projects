function [centers] = detectCircles(im, radius, useGradient)

origImg = im;
gray = rgb2gray(origImg);
bw = im2bw(gray);
bw = edge(bw,'Canny');
[x,y]= find(bw);
[m,n] = size(bw);
H = zeros([m n]);

if (usegradient == 0)
  for i = 1:size(y,1)
      xcord = x(i,1); 
      ycord = y(i,1);
      for O = 0:0.01:(2 * pi)
         a = round(xcord - (r * cos(O)));
         b = round(ycord + (r * sin(O)));
         if (a >= 1) && (a <= m) && (b >= 1) && (b <= n)
                H(a,b) = H(a,b) + 1;
         end
      end
  end
end



if (usegradient == 1)
    FX = zeros(m ,n);
    FY = zeros(m,n);
    for i = 1:(m-1)
        for j = 1:(n-1)
            FX(i,j) = gray(i,j+1) - gray(i,j);
            FY(i,j) = gray(i+1,j) - gray(i,j);
        end
        FX(i,j+1) = gray(i,j+1);
    end
 
    for j = 1:(n-1)
        FX(m,j) = gray(m,j) - gray(m,j+1);
        FY(m,j) = gray(m,j);
    end
    FX(m,n) = gray(m,n);
    FY(m,n) = gray(m,n);
    
   for i = 1:size(x,1)
      ycord = y(i,1);
      xcord = x(i,1);
      O = (atan2(-1 * FY(xcord,ycord), FX(xcord,ycord)));
      for O1 = (pi/8- O):0.01:(pi/8 + O)
        a = round(xcord - (r * cos(O1)));
        b = round(ycord + (r * sin(O1)));
        if (a >= 1) && (a <= m) && (b >= 1) && (b <= n)
            H(a,b) = H(a,b) + 1;
        end
      end
      
       O1 = O + pi;
        for O2 = (pi/8 - O1):0.01:(pi/8 + O1)
            a = round(xcord - (r * cos(O2)));
            b = round(ycord + (r * sin(O2)));
            if (a >= 1) && (a <= m) && (b >= 1) && (b <= n)
                H(a,b) = H(a,b) + 1;
            end
        end
   end
end 
  [x,y] = find(H > 0.8 * max(max(H)));
  centers = [x,y];