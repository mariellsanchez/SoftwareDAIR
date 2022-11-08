using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Back_End.Models
{
    public class EditarSesionAIR
    {
        [Required]
        public string Fecha { get; set; }
    }
}