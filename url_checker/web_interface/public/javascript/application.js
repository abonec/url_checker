$(function(){
  $('.delete').on('click',function(e){
    var id = $(this).data('id');
    $.ajax({
        url: '/urls',
        method: 'DELETE',
        data: { id: id }
    }).success(function(data){
        alert(data);
        location.reload();
    }).fail(function(){
        alert('data');
        alert('fail');
    });
    e.preventDefault();
  });
  $('#add_url_form').submit(function(e){
    console.log(e);
    window.evt = e;
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


