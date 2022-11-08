
using System.ComponentModel.DataAnnotations;

namespace Back_End.Models
{
    public class FormCrearNotificacion
    {
        [Required]
        public string Descripcion { get; set; }

        [Required]
        public string Fecha { get; set; } 
        
    }
}