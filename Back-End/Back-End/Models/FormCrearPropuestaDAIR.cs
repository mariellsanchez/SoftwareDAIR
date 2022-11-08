using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Back_End.Models
{
    public class FormCrearPropuestaDAIR
    {
        // SesionDAIRId
        [Required]
        public int Id { get; set; }
        [Required(ErrorMessage = "Inserte un nombre válido")]
        public string Nombre { get; set; }
        [Required(ErrorMessage = "Inserte una opcion válida")]
        public string Aprovado { get; set; }
        [Required(ErrorMessage = "Inserte un link válido")]
        public string Link { get; set; }
    }
}