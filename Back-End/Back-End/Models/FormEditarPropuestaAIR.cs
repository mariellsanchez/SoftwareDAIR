using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Back_End.Models
{
    public class FormEditarPropuestaAIR
    {
        [Required]
        public string Id { get; set; }
        [Required]
        public string SesionAIRId { get; set; }
        [Required]
        public string EtapaId { get; set; }
        [Required]
        public string Nombre { get; set; }
        [Required]
        public string Aprovado { get; set; }
        [Required]
        public string Link { get; set; }
        [Required]
        public string NumeroPropuesta { get; set; }
        [Required]
        public string VotosFavor { get; set; }
        [Required]
        public string VotosContra { get; set; }
        [Required]
        public string VotosBlanco { get; set; }
    }
}