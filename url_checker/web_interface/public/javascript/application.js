$(function(){
  $('.delete').on('click',function(e){
    var id = $(this).data('id');
    $.ajax({
        url: '/urls',
        method: 'DELETE',
        data: { id: id }
    }).success(function(data){
        location.reload();
    }).fail(function(data){
        alert('fail');
        console.log(data);
    });
    e.preventDefault();
  });
  $('#add_url_form').submit(function(e){
    $.ajax({
        url: e.target.action,
        method: 'POST',
        data: $(e.target).serialize()
    }).success(function(data){
        console.log(data);
        location.reload();
    }).fail(function(data){
        alert(data);
        alert('fail');
    });
    e.preventDefault();
  });
});


