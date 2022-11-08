using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Back_End.Models
{
    public class FormEditarDetallesSesionAIR
    {
        public string Id { get; set; }
        public string Nombre { get; set; }
        [Required]
        public string Fecha { get; set; }
        public string TiempoInicial { get; set; }
        public string TiempoFinal { get; set; }
        public string Descripcion { get; set; }
        public string Link { get; set; }
        public string NombrePadron { get; set; }
        public HttpPostedFileBase ArchivoPadron { get; set; }
    }
}