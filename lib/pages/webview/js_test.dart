String jsLeakChiMuc() {
  return '''
// Lặp qua từng phần tử <li> và trích xuất thông tin
var liElements = document.querySelectorAll('div.volume-list ul.pagination li');

// Tạo một mảng để chứa thông tin của các phần tử <li>
var paginationData = [];

// Lặp qua từng phần tử <li> và trích xuất thông tin
liElements.forEach(function(liElement) {
    var anchorElement = liElement.querySelector('a');

    if (anchorElement) {
  
         
        var textContent = anchorElement.textContent.trim();
        
        var liClasses = liElement.className; // Lấy tên lớp của phần tử <li>

        var liItem = {
 
            "textContent": textContent,
            
            "liClasses": liClasses // Thêm tên lớp của phần tử <li> vào đối tượng JSON
        };

        paginationData.push(liItem);
    }
});

// Chuyển đổi mảng thành JSON
var jsonData = JSON.stringify(paginationData);

// Hiển thị JSON trong console
 jsonData;
 ''';
}

String jsChapter = '''
var liElements = document.querySelectorAll('li.chapter-name');

// Tạo một mảng để chứa thông tin của các phần tử <li>
var liData = [];

// Lặp qua từng phần tử <li> và trích xuất thông tin
liElements.forEach(function(liElement) {
    var anchorElement = liElement.querySelector('a');

    // Kiểm tra xem phần tử <a> có tồn tại không
    if (anchorElement) {
        var href = anchorElement.getAttribute('href');
        var textContent = anchorElement.textContent.trim();

        // Tạo một đối tượng chứa thông tin của mỗi phần tử <li>
        var liItem = {
            "href": 'https://wikisach.net/'+href,
            "textContent": textContent
        };

        // Thêm đối tượng vào mảng
        liData.push(liItem);
    }
});

// Chuyển đổi mảng thành JSON
var jsonData = JSON.stringify(liData);
jsonData;
''';

String actionNext = '''
var father = document.querySelector('ul.pagination');
var aElements = father.querySelectorAll('a[data-action="loadBookIndex"]');
        aElements.forEach(function(aElement) {
          if (aElement.textContent.trim() === '?') {
            aElement.click();
          }
        });
''';

String textMoTa = '''
document.querySelector('div.book-desc-detail').textContent;
''';

String theLoaiJS = '''
var liElement = document.querySelector('.book-desc p');

// Tạo một mảng để chứa thông tin của các phần tử <li>
var liData = [];

// Lặp qua từng phần tử <li> và trích xuất thông tin

    var anchorElement = liElement.querySelectorAll('a');
anchorElement.forEach(function(liElement) {
    // Kiểm tra xem phần tử <a> có tồn tại không
    if (anchorElement) {
        var href = liElement.getAttribute('href');
        var textContent = liElement.textContent.trim();

        // Tạo một đối tượng chứa thông tin của mỗi phần tử <li>
        var liItem = {
            "href": 'https://wikisach.net/'+href,
            "textContent": textContent
        };

        // Thêm đối tượng vào mảng
        liData.push(liItem);
    }
});

// Chuyển đổi mảng thành JSON
var jsonData = JSON.stringify(liData);
jsonData;
''';

String tatHML = '''
var allElements = document.querySelectorAll('*');
allElements.forEach(function(element) {
    element.style.display = 'none';
});
''';
