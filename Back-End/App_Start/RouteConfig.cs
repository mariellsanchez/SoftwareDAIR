using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Back_End
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional });
            routes.MapRoute(
                name: "EditarSesionAIR",
                url: "{controller}/EditarSesionAIR",
                defaults: new {controller = "Home"}
            );
            routes.MapRoute(
                name: "EditarSesionDAIR",
                url: "{controller}/EditarSesionDAIR",
                defaults: new { controller = "Home" }
            );
            routes.MapRoute(
                name: "SesionesAIR",
                url: "{controller}/SesionesAIR",
                defaults: new { controller = "Home", action = "SesionesAIR" }
            );
            routes.MapRoute(
                name: "SesionesDAIR",
                url: "{controller}/SesionesDAIR",
                defaults: new { controller = "Home" }
            );
            routes.MapRoute(
                name: "SesionAIR",
                url: "{controller}/SesionAIR",
                defaults: new { controller = "Home", action = "SesionAIR" }
            );
            routes.MapRoute(
                name: "SesionDAIR",
                url: "{controller}/SesionDAIR",
                defaults: new { controller = "Home", action = "SesionDAIR" }
            );
            routes.MapRoute(
                name: "CrearSesionAIR",
                url: "{controller}/CrearSesionAIR",
                defaults: new { controller = "Home", action = "CrearSesionAIR" }
            );
            routes.MapRoute(
                name: "GuardarNuevaSesionAIR",
                url: "{controller}/GuardarNuevaSesionAIR",
                defaults: new { controller = "Home" }
            );
            routes.MapRoute(
                name: "CrearSesionDAIR",
                url: "{controller}/CrearSesionDAIR",
                defaults: new { controller = "Home", action = "CrearSesionDAIR" }
            );
            routes.MapRoute(
                name: "GuardarNuevaSesionDAIR",
                url: "{controller}/GuardarNuevaSesionDAIR",
                defaults: new { controller = "Home" }
            );
            routes.MapRoute(
                name: "Propuesta",
                url: "{controller}/Propuesta",
                defaults: new {controller = "Home"}
            );
            //EDITAR PROPUESTA AIR
            routes.MapRoute(
               name: "EditarPropuestaAIR",
               url: "{controller}/EditarPropuestaAIR",
               defaults: new { controller = "Home" }//, action = "Index" }
           );
            routes.MapRoute(
                name: "EnviarEdicionPropuestaAIR",
                url: "{controller}/EnviarEdicionPropuestaAIR",
                defaults: new { controller = "Home" }
            );
            //CREAR PROPUESTA AIR
            routes.MapRoute(
                name: "CrearPropuestaAIR",
                url: "{controller}/CrearPropuestaAIR",
                defaults: new { controller = "Home" }//, action = "CrearPropuestaAIR" }
            );
            routes.MapRoute(
                name: "GuardarNuevaPropuestaAIR",
                url: "{controller}/GuardarNuevaPropuestaAIR",
                defaults: new { controller = "Home" }
            );

            //EDITAR PROPUESTA DAIR
            routes.MapRoute(
               name: "EditarPropuestaDAIR",
               url: "{controller}/EditarPropuestaDAIR",
               defaults: new { controller = "Home" }//, action = "Index" }
           );
            routes.MapRoute(
                name: "EnviarEdicionPropuestaDAIR",
                url: "{controller}/EnviarEdicionPropuestaDAIR",
                defaults: new { controller = "Home" }
            );

            //CREAR PROPUESTA DAIR
            routes.MapRoute(
                name: "CrearPropuestaDAIR",
                url: "{controller}/CrearPropuestaDAIR",
                defaults: new { controller = "Home" }//, action = "CrearPropuestaAIR" }
            );
            routes.MapRoute(
                name: "GuardarNuevaPropuestaDAIR",
                url: "{controller}/GuardarNuevaPropuestaDAIR",
                defaults: new { controller = "Home" }
            );
            routes.MapRoute(
               name: "Constancias",
               url: "{controller}/Constancias",
               defaults: new { controller = "Home", action = "Constancias" }
           );
            routes.MapRoute(
               name: "AsistenciaAIR",
                url: "{controller}/AsistenciaAIR",
                defaults: new { controller = "Home" }
            );
            routes.MapRoute(
                name: "AsistenciaSesionAIR",
                url: "{controller}/Asistencia",
                defaults: new { controller = "Home" }
            );
        }
    }
}
