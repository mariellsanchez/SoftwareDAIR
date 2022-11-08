
using System.ComponentModel.DataAnnotations;

namespace Back_End.Models
{
    public class FormEditarNotificacion
    {
        [Required]
        public string Id { get; set; }

        [Required]
        public string Descripcion { get; set; }

        [Required]
        public string Fecha { get; set; } 
        
    }
}