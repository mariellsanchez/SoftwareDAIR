using Back_End.CustomValidation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Back_End.Models
{
    public class FormEditarDetallesSesionAIR
    {
        [Required(ErrorMessage = "Insertar nombre válido")]
        public string Id { get; set; }
        [Required(ErrorMessage = "Insertar un periodo válido")]
        public string Nombre { get; set; }
        [Required(ErrorMessage = "Insertar fecha válida")]
        public string Fecha { get; set; }
        [Required(ErrorMessage = "Insertar hora inicial válida")]
        public string TiempoInicial { get; set; }
        [Required(ErrorMessage = "Insertar hora final válida")]
        public string TiempoFinal { get; set; }
        public string Descripcion { get; set; }
        public string Link { get; set; }
        [Required(ErrorMessage = "Inserta página del padrón")]
        public string NombrePadron { get; set; }
        [Required(ErrorMessage = "insertar archivo válido")]
        [FileAttribute(ErrorMessage = "Por favor enviar xlsx")]
        public HttpPostedFileBase ArchivoPadron { get; set; }
    }
}