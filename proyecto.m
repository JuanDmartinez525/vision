clear all 
clear clc
cam=webcam( 2 );
    
wb=waitbar(0,'num0','name','espera','createcancelbtn','delete(gcbf)');
i=0;


while true
    img0=snapshot(cam); %capturar imagen
    
    img=rgb2gray(img0);%imagen en escla de grises
    img=im2bw(img,0.5); %imagen a blanco y negro umbralizada
    bw=not(img); %invertir colores
    
    s=strel('disk',3);  
    bw=imdilate(bw,s); %operacion morfologica para eliminar bordes
    bw=imfill(bw,'holes');%rellenas huecos
    [L N]=bwlabel(bw); %etiquetar monedas
    
    
    subplot(2,2,1);imshow(img0);title('IMAGEN DE LA CAMARA')
    subplot(2,2,2);imshow(L);title('IMAGEN UMBRALIZADA')
     
    %% propiedades
    prop=regionprops(L,'all'); %se almacena todas las caracteristicas detectadas
    
    
    %% contorno
    
for n=1:N  %deteccion en la imagen de la camara

if prop(n).Area>13000 && prop(n).Area<38000
      
centro=prop(n).Centroid;
diametro=prop(n).MajorAxisLength;
subplot(2,2,1);
viscircles(centro,diametro/2,'color','r');
end     
    
end

for n=1:N  %deteccion en la imagen umbralizada

 if prop(n).Area>13000 && prop(n).Area<38000
subplot(2,2,2);
rectangle('position',prop(n).BoundingBox,'EdgeColor','b','LineWidth',3);

end   

end

%% Escoger la moneda mas grande

BW2=bwareafilt(bw,1); % Selecciona el elemento de mayor tmano
a=bwarea(BW2); %Area de la moneda mas grande
v=0;

if a>35000 && a<37000
	v=1000;
	I = imread('1000.jpg');
	subplot(2,2,4);imshow(I);title(['Moneda de mayor denominacion: ',num2str(v),' pesos'])
end

if a<30000 && a>25000
	v=500;
    I = imread('500.jpg');
	subplot(2,2,4);imshow(I);title(['Moneda de mayor denominacion: ',num2str(v),' pesos'])

end

if a<24000 && a>22500
	v=200;
    I = imread('200.jpg');
	subplot(2,2,4);imshow(I);title(['Moneda de mayor denominacion: ',num2str(v),' pesos'])

end

if a<21000 && a>18000
	v=100;
    I = imread('100.jpg');
	subplot(2,2,4);imshow(I);title(['Moneda de mayor denominacion: ',num2str(v),' pesos'])

end


if a<15000 && a>12000
	v=50;
    I = imread('50.jpg');
	subplot(2,2,4);imshow(I);title(['Moneda de mayor denominacion: ',num2str(v),' pesos'])

end

if a<13000 | a>38000
    I = imread('cargando.jpg');
	subplot(2,2,4);imshow(I);title(['Moneda de mayor denominacion: '])

end
  
%% sumatoria 
total=0;
for n=1:size(prop,1) 
    
if prop(n).Area>35000 && prop(n).Area<37000
	total=total+1000;
end
if prop(n).Area<30000 && prop(n).Area>25000
	total=total+500;
end
if prop(n).Area<24000 && prop(n).Area>22500
	total=total+200;
end
if prop(n).Area<21000 && prop(n).Area>18000
	total=total+100;
end
if prop(n).Area<15000 && prop(n).Area>12000
	total=total+50;
end   

end
subplot(2,2,3);imshow(img0);title(['Dinero Total: ',num2str(total),' pesos'])


%%

if ~ishandle(wb)
	break
else
	waitbar(i/10,wb,['num: ' num2str(i)])
end
  %% 
  
  i=i+1;
  pause(0.001);
    
    
end

clear cam;