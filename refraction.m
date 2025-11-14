function [n_refraction,isTotRef] = refraction(angle_incidence,n,n_interface,n1,n2)
% find the verctor of the refracted or reflected light ray.
e = n2/n1;
cosAngle_incidence = -n_interface'*n;
cosAngle_emergence = 1-(1-cosAngle_incidence^2)/e^2;
if cosAngle_emergence>0
    % refracted light ray
    n_refraction = n/e+n_interface*(cosAngle_incidence/e-sqrt(abs(cosAngle_emergence)));
    n_refraction = n_refraction;
    isTotRef = 0;
else
    % reflected light ray
    n_refraction = n - 2*(n'*n_interface)*n_interface;
    isTotRef = 1;
end
end
