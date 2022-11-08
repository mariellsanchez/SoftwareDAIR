
using Back_End.CustomValidation;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Back_End.Models
{
    public class FormActualizarAsistenciaAIR
    {
        [Required]
        public string Id { get; set; }
        [Required]
        public string NombrePadron { get; set; }
        [Required]
        [FileAttribute(ErrorMessage = "Por favor enviar xlsx")]
        public HttpPostedFileBase ArchivoPadron { get; set; }
    }
}