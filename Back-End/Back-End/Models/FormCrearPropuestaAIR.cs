using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Back_End.Models
{
    public class FormCrearPropuestaAIR
    {
        // SesionDAIRId
        [Required]
        public string Id { get; set; }
        [Required (ErrorMessage = "Inserte una etapa válida")]
        public string EtapaId { get; set; }
        [Required(ErrorMessage = "Inserte un nombre válido")]
        public string Nombre { get; set; }
        [Required(ErrorMessage = "Seleccionar opcion")]
        public string Aprovado { get; set; }
        [Required(ErrorMessage = "Inserte un link válido")]
        public string Link { get; set; }
        [Required(ErrorMessage = "Inserte un número de propuesta")]
        public string NumeroPropuesta { get; set; }
        [Required(ErrorMessage = "Inserte un número válido")]
        public string VotosFavor { get; set; }
        [Required(ErrorMessage = "Inserte un número válido")]
        public string VotosContra { get; set; }
        [Required(ErrorMessage = "Inserte un número válido")]
        public string VotosBlanco { get; set; }
    }
}